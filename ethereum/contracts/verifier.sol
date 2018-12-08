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
        vk.A = Pairing.G2Point([0x1aab9b1beb2979c81ab5e28e1df1f54bacc1ff141691f7e1faea1e0eb019203b, 0xc47c9839a64648c8e0ab2c5fc764802dfd93e73044a783637d438bd3749b7f8], [0x817492efe863a2d81e6074f061073355d0ecaad05c540e599a4b335989ed71e, 0x2e0bdc1cdee689e06af41ee24582fdbb0d51fa6d2804311f7ac69177f60d3b19]);
        vk.B = Pairing.G1Point(0x131d6b726837a4693f9fa23806bdb41ed9053e276c78e7fd8b07c83a6ed966c, 0x10efbc6c60aae6a668acb2470cb64fce9514b530e6dea630b3aac7060ae1ad71);
        vk.C = Pairing.G2Point([0x1c5529a6a65418842e3459b40df8a3852534516fe851dd7572803e6b996268b2, 0x2ea3004ce7e81816deb46f55966e1862b787577e939f9ff3f8b012b2de852009], [0xdb798c428e01c7159f7c2dd5e7dbc5b6384d52dd1bd01af2e65bdb66ffdfa3a, 0x200f7f57f56c03dc57964a650c5eca47788584dbd72717d771747be488ea8f08]);
        vk.gamma = Pairing.G2Point([0x134b2b0fb7c58ee2370e46b76e0385e9667ac39cbcbf3146d995237fa9d0fd6c, 0x2012be6d72e64f3b8623467c760dea03259cdfd255941ccdfd2d0b34ff92e4de], [0x9c3b35ba1692ec89ab01fcafb621fc8c49678218a92c1c8ff3235d1d8d0595b, 0x29850e07ac583321415ac0206b30db94691ec57895d48a271ea0c0be1542cf0f]);
        vk.gammaBeta1 = Pairing.G1Point(0x2c31c43611f358b0e46d10f1fef9c993111d2294f45bc344e97d0c0a2b576143, 0x2679cb65290a6ddd073f0880f6e228c7a6476e3d2f2af62fc0ee1a4c545bebe8);
        vk.gammaBeta2 = Pairing.G2Point([0xf68e5e40a457c2e781288ce813e1e48d492b1eed4e5e1a0a18211d97437c7d7, 0x6548d2e52b540b5b9d81d82a42d9b49a986b5f809e68bde25da44fc0dc06003], [0x33f25ea10bd93fa007f8924ce9dd4479a796c0e9fdb3984b413f48807285ed3, 0x29086279321f3a0f5361c1930c0555300c42ed022ff2466ff07d636a9264bb0d]);
        vk.Z = Pairing.G2Point([0x23ba440ce57974e621ae7279557b264ee8a9958a5603f91b55d84e53be820caa, 0x12778365c31a51a54041f40b36277573fc829323d47664247caef11a8b79b0be], [0x1f015835d1257c2acb5b1b7f2761d16aa1a773e206550f32dfe68da5daae4ffa, 0x11494aa152e410e7d30d4a6dba87fada33959af71ea907cc9982d3548b5caa86]);
        vk.IC = new Pairing.G1Point[](8);
        vk.IC[0] = Pairing.G1Point(0x1503df973be27beeb944cd7b674ae7ce8fa24268225d2f41c885142db8bdcd9e, 0x1143391037014a7c0740072d20f430514ed0bf562e166b007303965a94d72b1e);
        vk.IC[1] = Pairing.G1Point(0x2bcb781395da60a8c91a1aa1ee7a0117ec275f158db9afe7821d90498bc42468, 0x2b84aec7a91f59fd673fefe67f7dfb33f6dab54fe7333a05a45c620d795d3df7);
        vk.IC[2] = Pairing.G1Point(0x225b0e444de41b52f6f63317d23283050a9a1a1c2c5def5a5aca9dce79ac1fb3, 0x269077658ed0ddf20f5d477816d403db6a96b31716c94119df7b1be9a7b98b07);
        vk.IC[3] = Pairing.G1Point(0x1fe4bc51f972b890f9bc3d17a60921c155aac05bcedcdc101dab2efe66eeb76f, 0x2564f7e60e38228d835d101313fdb43104ff3d22987c77e018a5af757b161c94);
        vk.IC[4] = Pairing.G1Point(0x34b03c502f27b0e92ec7620af82b653622433564d4e2ce8002fd79f0c6296fc, 0x229fa2676ae8c8e565ccccc0cd9a0c124f24663c7f10bc6e631af13fcb95d79);
        vk.IC[5] = Pairing.G1Point(0xd9d8ee5ae41e6265d1fa1e9a6df4a2501022e1d768bff4a88708806c18420ce, 0x2349f56466f3564e46c4a0944b63d11e81c067e4d9c6c59fd855997b173f3367);
        vk.IC[6] = Pairing.G1Point(0xba59676635b1e4b79ea7be544dcdbee96610b9a6a30fa52fd6a07177b4ac4d5, 0xa0c301ddc0e66349f22a859af89685060f9879f7d06abcfd4561e330c5df625);
        vk.IC[7] = Pairing.G1Point(0x25c91fd88f058d02d2cbe4c923ac9166e2d2072d94afd6b1549cc2d7a97c015d, 0x2736740d0e249ab5e401d43fb63737378e349a02b6fd0b9efab6ec3420b21202);
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
