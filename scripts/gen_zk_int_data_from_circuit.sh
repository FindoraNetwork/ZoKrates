#!/bin/bash
PATH_TO_CIRCUIT=$1
N_ARGS=$#
FIELD_SIZE=$2
PUBLIC_INPUTS=${@:3:$N_ARGS}


FIELD_SIZE_ALT_DIR=$LOCAL/scripts/field_size_alternatives
DEST_FIELD_SIZE_PATH=$LOCAL/field_size.txt

echo "************************************************"
echo "* Generator of zkinterface data from circuit ***"
echo "************************************************"

echo "Public inputs: $PUBLIC_INPUTS."
echo "Path to circuit: $PATH_TO_CIRCUIT"

# define the size of the field by copying the correct file in the root of the project.
if [ $FIELD_SIZE == "BN" ]; then
  cp  $FIELD_SIZE_ALT_DIR/bn.txt $DEST_FIELD_SIZE_PATH
fi

if [ $FIELD_SIZE == "CURVE25519" ]; then
  cp  $FIELD_SIZE_ALT_DIR/curve25519.txt $DEST_FIELD_SIZE_PATH
fi

# Compile the circuit
$ZOKRATES_BIN compile -i "$PATH_TO_CIRCUIT"

# Generate the R1CS
$ZOKRATES_BIN setup -s zkinterface

# Compute the witness
$ZOKRATES_BIN compute-witness -a $PUBLIC_INPUTS

# Generate the zkinterface data for the prover (indeed no proof is computed)
$ZOKRATES_BIN generate-proof -s zkinterface

# Delete the field size to recover initial state
rm $DEST_FIELD_SIZE_PATH