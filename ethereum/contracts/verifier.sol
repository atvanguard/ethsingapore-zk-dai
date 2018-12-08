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
        vk.A = Pairing.G2Point([0x215ff44af5dccdcafd41472845ca24154f60b0301b05d2a15582fc15f3e08286, 0x17604802c8db888e57db18a9bc0c318a5d1e4e8a2ccfeda9318721f41ab40665], [0xdb97913ade1136307023a5b8e90b33d4599af1b8c894c31adfbfdc31ef5417f, 0x1bd844fd7571c522c2f724264c7293193a7dcc72dce58eaa12bda4df3758a475]);
        vk.B = Pairing.G1Point(0x274e48bf8bddd413a02df08e29b26bc3d4ebf50d9dbd64eccb67533c2465e4d2, 0x2f22df3391bf98351d813543961a96dc31a069f1f2355d6d86a35eea8250961f);
        vk.C = Pairing.G2Point([0x2c5fc5ce9fd16ecaf43d491daab042bb92d11b9a8ef6dfb81454c6c43a21d0aa, 0x29e577762ac0b26c971e0104f3b30d4f09b49681609dcd81729ab1d580bfe040], [0x1cd745ef23946d1ae259cff66d4fcbbe17809d6d59bde9012d4e8b2ce6c329cb, 0x2918f78da6c328275edad0bf5ccd949b17b2c3b8d6cc8d45b65540f453083b35]);
        vk.gamma = Pairing.G2Point([0xc98e6d14fb379b89f8f519b1f2449e9ffbb0173d3ea42de33d3d9cf1b7c2736, 0xbbb13e2febf9861f72ba6ff6ca5fd0cafb5721d394dc96b00ed1d451b6f3c81], [0xbff44da1d3f0ec1be6e0a4b7c6bb61d62b94decc2320a20ad535a063757a47e, 0x1c3ff01773c43645846c6609740d9f1afdb07c8ecdc027af868e591cfaa36ded]);
        vk.gammaBeta1 = Pairing.G1Point(0x86f4ce29e4a3f13b15d7aa52333d086b890f5f549c36b9ab7d154c954a43f76, 0x7e12dcae0ca130af763d472878d8b48c6764c89eedece96e191f02af81be8ae);
        vk.gammaBeta2 = Pairing.G2Point([0x12c3c025476dc36afd28f9a033c79c6368a2ffa6c61d2f2d1346daf2f523e899, 0x250d05ce866530dd20808d942e3a1a65a1f0668aac8221ebbea8840a4c5ba4a], [0x2f8c788eb5feccb2597106c3ad28c59544fcd8ceaa62d8d24fb267bf39321327, 0x31f49f4948278b3ea7513021cf005296848fa9acc220e3e1e89a832b087d1cb]);
        vk.Z = Pairing.G2Point([0x15694654828949cfcabe023a7773d0bfef9ae8d94d05e5de0cf30d737b4d35b, 0x1d39c4fe911ec8cd30606496c768a5b9057c13022f92ebe719aacf0866466d5a], [0x1eb9c00340ec1ceb7d5e0eb7af5e983c14f640cc823a37adcc2149295095ccd7, 0x1191203e03b0088ef5134442dd6ef1c4774e0c7df25f65b1976b02db036379e]);
        vk.IC = new Pairing.G1Point[](8);
        vk.IC[0] = Pairing.G1Point(0x443b13df6580b6613c081346893f708412a83ddf241f0b4c4ec4875f84d7ee6, 0x2156e5111d1b5eb0ace99f68de22db8e3d90d75f98457ebd4318aa31f1943d9f);
        vk.IC[1] = Pairing.G1Point(0x1bf260351f5d97dfdcf8dc7885deb20631d23de6a752647c3f73a0bd925b03cc, 0x1712e5063e001d5839dc7224d1af01b58b034ae6ae52f45387f2560464216b44);
        vk.IC[2] = Pairing.G1Point(0xcbec21b755ee34349bf3ab2eb73953fd0ee0ad4f357d7e652223fa3d42d465b, 0x21ac6e6d1dbd36e2192538d19fbf43b7519cebebd482255a72f605ff4e8eb6a7);
        vk.IC[3] = Pairing.G1Point(0x2a10d3b9b7043854a600a193b65d740748c7fc71e7b53cdacd24c6e2f75e35f3, 0x95ab96c842e56bfd12969d2d7d819e7813c262e2d5145b8b6b264f96522a9f2);
        vk.IC[4] = Pairing.G1Point(0x112bf9c11207aed1a767ae773d2d87f4e4f4637c5478697f07a4b0712ba46f37, 0xa6f8f9a2b30476df6a48ebc1cafef7b036f1d1ef9d28928b24f1c8fa360b49b);
        vk.IC[5] = Pairing.G1Point(0x8f928622e69d4e214ddf712879b1a99a52fc69c200434d72d72eb1a3ce71293, 0x2b9256eb515dada2d8ed06d525f3f3aa818c6481add0a9962654c328066d7fcd);
        vk.IC[6] = Pairing.G1Point(0x40b9ec20b236d765c28dd81cfd521a279d8b93b9681c0f03c571bfa2650bc70, 0x9bcd62759344d4129a21165d81a8cbc9358701146af7ea7c13842933ed4eaf);
        vk.IC[7] = Pairing.G1Point(0x2067374ba01fba18bf4715e48b96dfb03d79fc1353866262163930391615982b, 0x223118635aa6f4b82bfd4e4a642be6b83d7e57cc09b3391206bed284ac9f9e7);
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
