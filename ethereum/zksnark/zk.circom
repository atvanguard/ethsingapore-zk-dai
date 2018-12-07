include "./circomlib/sha256/sha256_2.circom";

/* template Main() {
  signal input oldNote1;
  // signal public input hashNewNote2;
  // signal public input hashNewNote2;

  signal private input pk;
  signal private input onVal; // oldNoteVal
  signal private input onNonce;

  component sha256_2 = Sha256_2();
  sha256_2.a <== onVal;
  sha256_2.b <== onNonce;
  var hValNonce = sha256_2.out;

  sha256_2.a <== pk;
  sha256_2.b <-- hValNonce; // could be wrong
  var hNote = sha256_2.out;

  oldNote1 === hNote;
  // sig verification
} */

template Main() {
    signal private input a;
    signal private input b;
    signal output out;

    component sha256_2 = Sha256_2();

    sha256_2.a <== a;
    sha256_2.b <== b;
    out <== sha256_2.out;
}

component main = Main();

/*
signal private input a;
    signal private input b;
    signal output out;

    component sha256_2 = Sha256_2();

    sha256_2.a <== a;
    sha256_2.b <== b;
    out <== sha256_2.out;
*/