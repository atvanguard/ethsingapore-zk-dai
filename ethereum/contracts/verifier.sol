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
        vk.A = Pairing.G2Point([0x19c71235f6fa4f6e868ae36717f32b05ef9ab47e8ba8acecf46c78876c03e9d3, 0x104a52cf678f893a3f3f013d8edbb2b966c90bf5ebb4fbf17b3ef54e251d78a4], [0x2249e4ba346e344242421f0340eacd276d8cf3e411da62340def4da494510e12, 0x24eeaa671bd2a3f7f9d4c4831677b6d8a8092b9824ea7bb86c3ec1ac519466c7]);
        vk.B = Pairing.G1Point(0xbc24d82bedf38b5440013936ca9bce102e5e6950c48d9ad8d240a1918834da, 0x1e08f26bafc121cf60cb38d6d885639acdfc7fa97dfcf59acd617760376dc163);
        vk.C = Pairing.G2Point([0x16d3d66d457b88845cab2bfcc80d119c4c990e418fd32c223d66acf5d730bd79, 0x2621348fee105d160846de43f9085e6c97ef36d923c6b12bad59a06d4cd67790], [0x15d90f1ea3e43aca5f5eacaee4a750d50d47cc4314dfe83eb3d4d85de10c7df0, 0x1d5aa223d20e7e8949e7f1ba5608c3f955eb24694449a3558fe8c77344b52c7b]);
        vk.gamma = Pairing.G2Point([0x1e6c47e84987f1d04a0f65c183db5129c85b3e61554f12db0247090ad921c1ff, 0x5ba5ee3faa025f83e9063d6080fcfa45fab5436b553ed42969fc46cc2b49762], [0x2b91af821c43ad3a7d7a8fa57c1a93c8f319fe1fe3bcf842f8f2f2f3036fbdc6, 0x1a1a6e90aba36eb6f84afde36ce456add3ca719b559ebf6aa451c05e98de73ee]);
        vk.gammaBeta1 = Pairing.G1Point(0x2dcecf66dc477d9ba014e56dcafe4ec65a1bfbeef0ba36cf91485074925c3f18, 0x218f2c7d973e1f318b5ade3e844dc982bebe5728754f983d80e8f077e17cb653);
        vk.gammaBeta2 = Pairing.G2Point([0x2bd6eeaba12846c349033d0296107a1ad880024b95f175297ba67a0362681b4f, 0x5369df0c21c90a21b89109769b897e256867e539296a9ae7e3a6ab01cb191d5], [0x172ac74542167a92da9c783c88cd7695225f734c22381d12b747d21ceaa3a794, 0x21a01f99f1eeb11189d2a073dde9a26e3fc5b36e613bc35a850fb119fddf9071]);
        vk.Z = Pairing.G2Point([0x2f5d53f0461269e746c1a93e74a8f979e346d1820b49dfa06767b2352cc44c91, 0x297ccd8a7217827f212327ac8531e8d0f40ce11ecc3639924b65549646827942], [0x49ffdfacbd89f84cd92977cdef352e2aa7f666d0652d4241dcf580a59ac070d, 0x121edccc64c45532c20aff64325978b673a9a6c262965213246383f831539cea]);
        vk.IC = new Pairing.G1Point[](8);
        vk.IC[0] = Pairing.G1Point(0x3c264441f252dd4076c96b08e248b26af262865880c963862b25f54ff7d6bc, 0x47772002487b153535656f30a6be1f0b8d77cb9cc675194a715466c77b128ab);
        vk.IC[1] = Pairing.G1Point(0xfac4dd2386fd19672251d43c089e166721a8e4a3647e5eb3cbf3ef5205184d1, 0x89acaaaa2c402ff5201e45423333224d7b6f09b68bf383da808276a4c3817c);
        vk.IC[2] = Pairing.G1Point(0x1f3851ac41022d1cc8421a57b3aeb366fbf3a739cbc7765cd45951bb374c48b7, 0x22bbe3563e2215bcf80f4cf17cd43841a89ca4948ccde95b529b675889ceee8a);
        vk.IC[3] = Pairing.G1Point(0x26a3047286fdf3b2371c69fa22685237e2383464d366119978fa992beaace458, 0x27c4821aac53416aa991b087767dc4c1b809a60df526a3050eeba8305874ecfa);
        vk.IC[4] = Pairing.G1Point(0x125d531481e237ef1c513ffa87c6683e7d48ba23dd09d0a1f404be93710faa0a, 0x2ac3b9a239330ec8738d9b2f2443953a08b784b189f31633b4a5f36c8afecd31);
        vk.IC[5] = Pairing.G1Point(0x1a2bc18c294dddef4f5f6fea036a58961528c2ac13dcc50c859666f4246c1614, 0x7d57f3f659b73664a163c91d4ea9e6b5f3f73c589d962a4f40a16482689719b);
        vk.IC[6] = Pairing.G1Point(0x75d9a71677599f30708e79584ae1fde71a3b266203529c31e8f3288409ef896, 0x17b0fd7694fe3a8518c435a2ab2489863c932cc7a74c3b57a93b71a4906686ed);
        vk.IC[7] = Pairing.G1Point(0x2fa7869db5beed03a31eb094857da4eef91d6cbe391d6e45fbfa4d2ecddcac49, 0x19f9dde6270b52b594c8cd5d646241f857f1cc069a05c18c694fa032dcec7dec);
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
