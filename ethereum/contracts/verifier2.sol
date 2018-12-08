// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pragma solidity ^0.4.14;
import "./verifier.sol";

contract Verifier2 is Verifier {
    function verifyingKey2() pure internal returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point([0x116e30dc4d355ec744dcbb4285e58b3d47feda0c687572a0fbef85fa72aa0de6, 0x5ba3aed40302463d08413f3c137676a4f34da6991deac1afa278cb4ad379eb9], [0x11fa587b99e0aa662abb939af37999494dcb4fa3aa3290f3f52263f9b5f5cd72, 0x13f5db97936a305a08049262ece2825106e1b085151341d8cee7faf1c74d0c33]);
        vk.B = Pairing.G1Point(0x2add8d5da504ef14516fb10a667b00ffb357bd0afbac68be1801ff90725fc8c5, 0x150812b297cf71d0a47d90f852c79abe4d5c8827cb3423cca4dc4b79c20b7815);
        vk.C = Pairing.G2Point([0x1fb96fa6df2b84a794cc0bb1a30d374e47cc705667269bc2012904fe1b2084cf, 0x2e8f8ff6af921ed0471018e5bb0d373331169359331d03266574783f94a48157], [0x1b5fde985409d3bb773c838a99dd47603ee143c2a1ac08f68f4db9ab8d59b883, 0xc5072894353e6c3ac1e0f0eb7e3bc1e49baea1190297c82fbffb9502986de76]);
        vk.gamma = Pairing.G2Point([0x28e60ee6f14bc4ef30d0d8f0225b0bdd16e9348807d465ef638c46b227f5fb7c, 0x17c567c513c00c406b817aa4000ddea36cf427271726a1b426dcb330bd301701], [0x150d47f23189aca71aca0861df61cd0574ffb0d6453b5cf047f3acf5addc502f, 0x1be0a130c69ff86b8eed92eef405c1fb0019bddaa0277e99790ba158e806f3cb]);
        vk.gammaBeta1 = Pairing.G1Point(0x1d8503239eaa2058cc5b0a9c1d6c5c8dff3df72455745a4e072f61aacf4d07f3, 0x13b9c76acfb1f932895cad868cd0e31f7e3719e3b85cb98dbd4532010c42e1c1);
        vk.gammaBeta2 = Pairing.G2Point([0x1f43f2e9489fd92f205db6b57c6383fdd2bc8238f0352b934b0208e0d2e41ac2, 0x192388d7d41b72969eaf821acacbef5aff90d9cd0aba6d2dc51712b4faccaab6], [0x27c400bde9dc7ad9704a1d22a81a9c961bdb18ac846eb9b57b786c4a1fab654b, 0xad8a57ef9128fa5938d265cbca21b93e0b8e6a4bcf4675b04a66f0b7a26fb7a]);
        vk.Z = Pairing.G2Point([0x276cb922eacf6043283b8cea20cbc4d5c1db068335f1247872806a5aea1bcd72, 0x169277aad9320ba144d31da2e40b0de89726467c2b322d27afc9b8f36e01f802], [0x2e724507451c41f7c781fd607d025b933258fcc76b0b7d04ad117ea1fd7d2531, 0x2abe0f1e39f906ff428dbafec9e174ec6a5cb04e8e2246b5bb63d993894a41f8]);
        vk.IC = new Pairing.G1Point[](6);
        vk.IC[0] = Pairing.G1Point(0x2f8886f54c025379e97e25672794030df3d4806fcfdcdb6f4d41ddfa4fc4f33b, 0x46b11fda376254f27b9d41d6eb578047aac1b7c4beb5e5e02b7c531cb49dac9);
        vk.IC[1] = Pairing.G1Point(0x27fb86caf68baf92cb47cca12719b24552c977b672ff9d2b5028700901207fe1, 0x28dbab42ffae2d1e2ff16b6c894781dab5140642c9d14b67e5ccf4df8ea08622);
        vk.IC[2] = Pairing.G1Point(0x220fa546dc2bf7cf634d13498f810121a8ec144731fa3fa28a391249b82fefe6, 0x1b2cabae5d0fafa4a8024253db978a20c3c44febe785d420f93af9324727c81e);
        vk.IC[3] = Pairing.G1Point(0x4e37cf00835c9beb19be93c17871b06240a63134ba1290f914a6e996730a6e8, 0x2dc8cfe797982154c10c288cf087bc6a496787170554ca126b061f10fb5831c7);
        vk.IC[4] = Pairing.G1Point(0x152b81ab5fcd8cd3e69146d5e9daba81698a8223d409a4f15ef780a6a81f86fe, 0x146130cb67825b7d108f6165439493a3c3da83a9b7370a285eed628179e350db);
        vk.IC[5] = Pairing.G1Point(0x1d9cca7f375972a0e221ea3f4c859d8b936f50c86a2e7405cec9fbd537f02925, 0x152d58df1e0e2644641efecc39b99d7f8c64fd20ce4d3c7f1442c20363911886);
    }
    function verify2(uint[] input, Proof proof) internal returns (uint) {
        VerifyingKey memory vk = verifyingKey2();
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
    function verifyTx2(
            uint[2] a,
            uint[2] a_p,
            uint[2][2] b,
            uint[2] b_p,
            uint[2] c,
            uint[2] c_p,
            uint[2] h,
            uint[2] k,
            uint[5] input
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
        if (verify2(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
