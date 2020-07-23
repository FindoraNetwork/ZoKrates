#!/bin/bash
PATH_TO_CIRCUIT=$1
N_ARGS=$#
PUBLIC_INPUTS=${@:2:$N_ARGS}

echo "************************************************"
echo "* Generator of zkinterface data from circuit ***"
echo "************************************************"

echo "Public inputs: $PUBLIC_INPUTS."
echo "Path to circuit: $PATH_TO_CIRCUIT"

$ZOKRATES_BIN compile -i "$PATH_TO_CIRCUIT"
$ZOKRATES_BIN setup -s zkinterface
$ZOKRATES_BIN compute-witness -a $PUBLIC_INPUTS
$ZOKRATES_BIN generate-proof -s zkinterface