pragma circom 2.0.3;

include "./incrementalMerkleTree.circom";

template Main(levels) {
    // The total number of leaves
    var totalLeaves = 2 ** levels;

    signal input in[totalLeaves];
    // signal input hash[32];
    signal output out;

    component checkRoot = CheckRoot(levels);
    checkRoot.leaves <== in;
    out <== checkRoot.root;

    // for (var i = 0; i < 32; i++) {
    //     out[i] === hash[i];
    // }

    log("start ================");
    log(out);
    log("finish ================");
}

// render this file before compilation
component main = Main(6);

