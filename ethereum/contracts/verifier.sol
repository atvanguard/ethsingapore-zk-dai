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
        vk.A = Pairing.G2Point([0x1a8f6dffaed1c959a7d71aa2657a2a789c8cf89f326b588c05ab37a9f39e1b4e, 0x16e8c896c9f76efde51c34cf38958f1d135e640938bb93b3fe1b916afbe2180f], [0x555d5dab0f873f97e7678be2a449985c768165af93602d4d16972816f3f16d1, 0x1a3cc67e34d012cd4e4f3fb518360e02c302e4d686a91f5986697865ace1caa4]);
        vk.B = Pairing.G1Point(0x13d238247df32190384980ed184e542ac93ddc5979c5db32e337b4ec609d33fe, 0x25f1dd410d4f3e32985866c99bf12ee9dbd00f8d7199120a9c773cf497d4c7c8);
        vk.C = Pairing.G2Point([0x2da063c189bf638f9c002b7c12419c0f06e17b80838454af497b0a17d6152342, 0x3b5a992bf33a454f0dcf9fbb9d789ce1f54475c5d51d93919494f62cc2e6097], [0x1e128bdc2bbd373e265113a5c2c5baa41c4831e50005260d702421dae2a028ec, 0xba58826e1eb8e21ccc98da25bd87af438cff5c28297807f687aafc56ddb9e21]);
        vk.gamma = Pairing.G2Point([0x28921c80556a6fcce84f693cac87c0f8772ecd4511b1383f39f50837df73770a, 0x5dada211aa99b96d72fd7164b99c65b51b6e9d72161a50b85c365af1e0e4ea7], [0x21da090cbd4f5b7551d41aed5ee9ba64b6c8a42c7e1824296420f1f964adf50, 0xd94b34e3ffc829279f46e39b6bf15e129225c67f0fdad865b96dbb320e32c89]);
        vk.gammaBeta1 = Pairing.G1Point(0x4f700830971f262c6b64ea7be3f1d83e540f08d6c4602ceda8b4002757bb08, 0x15b17a574ee3017c65ccb79b5352025473d1670ba8b1a6f4d75036a27b7164cf);
        vk.gammaBeta2 = Pairing.G2Point([0xdcde8fac990ca51c4a30e6b8d3d65fc603e8f4c697b2751b518bfb62c3766c8, 0x206a0b60cf83518fce1a034beaac502dbb88facf91a5e0781038697e9b35bd51], [0x1e2a317cc69ce2f8c9602e61d204de4c9a388c811670748b8ef8c1dc1cb74f51, 0x30b94e7e1f772aa30206e8dd9c8bacc40418da6758ed456be78240d0c7dae06]);
        vk.Z = Pairing.G2Point([0x147446f69a2130e8b430a91d539ed116a4fe6a355ff3965b126fbc7d726327ce, 0xd8aece85d17d3935909e9b40633d8ee762bb3b2d385606e95095794859cc0cc], [0x1e1ff543c3e4898147e5b53bdb7afd09b021539a287f86bdca21de042c698a31, 0xbaf91af14027a68bd44d9752570c5e8bd3811203fe45daa6dfe26dc3dc1d94d]);
        vk.IC = new Pairing.G1Point[](8);
        vk.IC[0] = Pairing.G1Point(0x7a9ca7be3dabc10b743e4197fdeb58336f061b5b298acaabad3856857c444c5, 0x297369c7601b9f352bc72bdbdc9db0a45a53d2005ac1ac5b465484b550dc37cc);
        vk.IC[1] = Pairing.G1Point(0x2b613dd24e9637212712b7e544254283766556df4ef593fa12f0304bbbe42e79, 0x2e454ec4cca92db576a178f1d974a3b5764f20d4f8d24dce4c5739477da3770e);
        vk.IC[2] = Pairing.G1Point(0x1b67fd85eca0e51c466d5e745afee799f48aef820fae99c5de7a755bd95f796d, 0xb1974ae8e2ce51f931c2df183312aa426f6f9e6598d913fc7e571384cff5002);
        vk.IC[3] = Pairing.G1Point(0x949bb1e30664f373d9abf5be86c66a886d0fad11fda0a47fcdc33d36285dea3, 0x8d8da79e509592eb1a981e96a0cf02aa4a148cc795bad859576ee0d65f2935a);
        vk.IC[4] = Pairing.G1Point(0x2c74a3233ca44615eae03effad335f6c1dd1ab2d9e8df100662855325df478c, 0xae767525b2d60cb58bbb83bd6619bbc8a16fca0c350dc690048c4bcac54a50e);
        vk.IC[5] = Pairing.G1Point(0xd895438a8263bb4806def515d34f0045a4e053dc4322b236983694736086ea3, 0x18eb2ad17e99cd883a85289b2425c30bd0ca8ec8c337edea9beb6cbb6c9b6ffa);
        vk.IC[6] = Pairing.G1Point(0x2e81bd8679092fe9558f1a720781a38bc85893e9a8f5bfc588f0df175fb5fcb6, 0x430be466714efe5e9f3134b8303b92553289571a7e338c283f1591a458886c7);
        vk.IC[7] = Pairing.G1Point(0x1e4d988b5a23db2a6623dafdafe16fd5f93ba4131a621a2eea571515669c4de6, 0xaf140f4d92d62259a0409837a8027056692f0bc63cb402f66303a9855849160);
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
