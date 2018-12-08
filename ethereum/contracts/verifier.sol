// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pragma solidity ^0.4.14;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point p) pure internal returns (G1Point) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function addition(G1Point p1, G1Point p2) internal returns (G1Point r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point p, uint s) internal returns (G1Point r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] p1, G2Point[] p2) internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point a1, G2Point a2, G1Point b1, G2Point b2) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2,
            G1Point d1, G2Point d2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }
    function verifyingKey() pure internal returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point([0x8e36b4d2756b53f5251e82d8165221316ec067c2481efe2958a113ddfa4281b, 0x23b9b66fe61679968d3cccad8002a3c5b0ce28d3e59a612d160359ebf6786ac8], [0x1831b14d3f751e661527f361796804e319ba91fa785b34975ec48b7dfc823314, 0x198886847d5eaa0095b97694d30043a053c1be9222e0911522a6cb3900b5ceef]);
        vk.B = Pairing.G1Point(0x152297defbbf76d445a6673296626f69e4a97037d829b2e3c8019e5684497dc, 0x1a5ef8fda8fc033dd1b773e2d942c7e9a999bbfc97bef1fccf551a9fbe316d3d);
        vk.C = Pairing.G2Point([0xce6e53f3d81e50846a16091601d50f9e78273866e3f2400235b0c95f0419296, 0x1b216d69cc445244cdba42bb530247d7445697e742a7146150ac19063e8b1e66], [0x20cb68030dc78b586b865708911a5a09ffb1bb31cc4a5341e8d2dd2aaf5f2aa, 0x1626a5c67b2efead53b3615d4024b6a5e594036981533837180b01918e6fb2fe]);
        vk.gamma = Pairing.G2Point([0x2c7b8befbe852f5602cb35735b768b6c4801da043a478cb46c2e2ee97d3ed47a, 0x99bfa50a654da1d2f59b0663f51e971df97fc8df6170d21da0a9b75f47c2549], [0x2a7ce5949d8a8d930a9c30acc27c024d6e98fcb60fb3cf76a938aed6c8fbf614, 0x142a4aac09b5a1e99414efd27ae28ec96266e2dc0aebd66058df6ff99f6e2646]);
        vk.gammaBeta1 = Pairing.G1Point(0x26f78d04e26268f44ae9b2d8dc17d9dcd4e339c984bb4c4778e40672b5a7b5c4, 0x190ccaa145ea56450f806cb032336523c4b45fd0abe1c737701b4e127db12c27);
        vk.gammaBeta2 = Pairing.G2Point([0x11e3c125e138d67e45383854aafadcf2c0827ad7e90560fdf692db58667fa19e, 0x257488754ff3e39dd598a02c50c20075cf94d7f79bd47ba7b37d21d5a7d6d73f], [0x1264446b710d5384100d2fff1c9dc496325d1f84080cf936196817751c0da1a3, 0xcc57f9b481f081c08e332635e8fe2a18b413c684a5d3b041ec3d7344bd874c2]);
        vk.Z = Pairing.G2Point([0x2734bbf6688cfe7dc264e4f88552222c4adf4cb780e104faf759b776aac21d0a, 0x28231ec8a3ffd9bfd9495d169bd5d70dbcf5554c5558f6b3b198a5c91b0d3446], [0x99dad14a00ac1051226a0d78261f1e464cfc9391b9b236b1530d193e78fbb0e, 0x2aac94ff631724caaf729d95db664ef73a73d3809739f20f4a706c50b68df5b6]);
        vk.IC = new Pairing.G1Point[](8);
        vk.IC[0] = Pairing.G1Point(0x13750d82f2b679dc4ad0867253f43d1bced36ee91887c9744ecab4aba5c45ee8, 0xa53bf95dab12022bdc37dbb02438d6c8ff39d1f04cef77ca30877d0adb16d9c);
        vk.IC[1] = Pairing.G1Point(0xfe2c88bd239ea004343693f3586abe22d54b6ac45fce69ce978bca2935125ec, 0x2e67e52e92276387ad316fb3863692ee82844f4f895813989652a1d2a2b876bf);
        vk.IC[2] = Pairing.G1Point(0xbe019e86beed55a9fdefb65db20b03e77b390b7c31fdf6aa77737d67ca56885, 0x3fe056d28fd35961ca54de24f155df26ddf73bb0f091eba28b027d9ab11e74a);
        vk.IC[3] = Pairing.G1Point(0x2d4cdf32b6926410525b4689ec7fc1f4a1fb9a3f8339607b35bbcc12ea6516e9, 0xed0aca4a3fc40de2f2ae6e794cfd6ad1e92de77150cc4bc14d6e8ef2e00a57a);
        vk.IC[4] = Pairing.G1Point(0x22c725caba5c03935a5ba390182457dd689d079fd705f0cf8469a5c2071a7a2e, 0xcc1b06ad8a59d601fcdf38277fa25e93125f602d52a28981c0025f934a4a632);
        vk.IC[5] = Pairing.G1Point(0x7b238b7431cdf1adb2b366b7640515c2cedea3a64670ad706a902643b1c0fcb, 0x21f8d6c2802190c0442bd9f76711412d99fc35a928e7c85e64b827177d8d46c5);
        vk.IC[6] = Pairing.G1Point(0x15ac63102415044a2aefa516e1f57835e913f0e8a30a2b8ce0ccd9c97a2171d1, 0xadd7bed91dbd33baf21e7b9b4fd59ca50dcea3125cddba44aed4af98151912d);
        vk.IC[7] = Pairing.G1Point(0x194f37d7035364240daa6a75921638b40dc77a708c58b08c7e96546d078ce389, 0x16c391945a99cf1c2df6700e12cd119d96dc2329d8d079cb5f95635ab9ee87de);
    }
    function verify(uint[] input, Proof proof) internal returns (uint) {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++)
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd2(proof.A, vk.A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
        if (!Pairing.pairingProd2(vk.B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
        if (!Pairing.pairingProd2(proof.C, vk.C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
        if (!Pairing.pairingProd3(
            proof.K, vk.gamma,
            Pairing.negate(Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))), vk.gammaBeta2,
            Pairing.negate(vk.gammaBeta1), proof.B
        )) return 4;
        if (!Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A), proof.B,
                Pairing.negate(proof.H), vk.Z,
                Pairing.negate(proof.C), Pairing.P2()
        )) return 5;
        return 0;
    }
    event Verified(string s);
    function verifyTx(
            uint[2] a,
            uint[2] a_p,
            uint[2][2] b,
            uint[2] b_p,
            uint[2] c,
            uint[2] c_p,
            uint[2] h,
            uint[2] k,
            uint[7] input
        ) public returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
