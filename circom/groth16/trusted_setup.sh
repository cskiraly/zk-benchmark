#!/bin/bash

if [ $# -ne 2 ]; then
  echo "tau_rank required"
  exit 1
fi

SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
CIRCUIT_NAME=$1
CIRCUIT_DIR=${SCRIPT_DIR}"/../circuits/${CIRCUIT_NAME}_test"
TAU_RANK=$2
TAU_DIR=${SCRIPT_DIR}"/../setup/tau"
TAU_FILE="${TAU_DIR}/powersOfTau28_hez_final_${TAU_RANK}.ptau"

if [ ! -f "$TAU_FILE" ]; then
  wget -P "$TAU_DIR" https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_${TAU_RANK}.ptau
fi

pushd "$CIRCUIT_DIR" || exit
snarkjs fflonk setup ${CIRCUIT_NAME}_test.r1cs ${TAU_FILE} ${CIRCUIT_NAME}_test_fflonk.zkey
snarkjs plonk setup ${CIRCUIT_NAME}_test.r1cs ${TAU_FILE} ${CIRCUIT_NAME}_test_plonk.zkey
snarkjs groth16 setup ${CIRCUIT_NAME}_test.r1cs ${TAU_FILE} ${CIRCUIT_NAME}_test_0000.zkey
echo 1 | snarkjs zkey contribute ${CIRCUIT_NAME}_test_0000.zkey ${CIRCUIT_NAME}_test_0001.zkey --name='Celer' -v
snarkjs zkey export verificationkey ${CIRCUIT_NAME}_test_0001.zkey verification_key.json
popd || exit