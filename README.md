
<img src="http://www.redaktion.tu-berlin.de/fileadmin/fg308/icons/projekte/logos/ZoKrates_logo.svg" width="100%" height="180">

# ZoKrates

[![Join the chat at https://gitter.im/ZoKrates/Lobby](https://badges.gitter.im/ZoKrates/Lobby.svg)](https://gitter.im/ZoKrates/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![CircleCI master](https://img.shields.io/circleci/project/github/Zokrates/ZoKrates/master.svg?label=master)](https://circleci.com/gh/Zokrates/ZoKrates/tree/master)
[![CircleCI develop](https://img.shields.io/circleci/project/github/Zokrates/ZoKrates/develop.svg?label=develop)](https://circleci.com/gh/Zokrates/ZoKrates/tree/develop)

ZoKrates is a toolbox for zkSNARKs on Ethereum.

_This is a proof-of-concept implementation. It has not been tested for production._

## Getting Started

Load the ZoKrates Plugin on [Remix](https://remix.ethereum.org) to write your first SNARK program!

Alternatively, you can install the ZoKrates CLI:

```bash
curl -LSfs get.zokrat.es | sh
```

Have a look at the [documentation](https://zokrates.github.io/) for more information about using ZoKrates.
A getting started tutorial can be found [here](https://zokrates.github.io/sha256example.html).

## Getting Help

If you run into problems, ZoKrates has a [Gitter](https://gitter.im/ZoKrates/Lobby) room.

## License

ZoKrates is released under the GNU Lesser General Public License v3.

## Contributing

We happily welcome contributions. You can either pick an existing issue or reach out on [Gitter](https://gitter.im/ZoKrates/Lobby).

Unless you explicitly state otherwise, any contribution you intentionally submit for inclusion in the work shall be licensed as above, without any additional terms or conditions.


# ZkInterface

Zkinterface allows to compute some intermediary representation of the R1CS constraints and the witness,
so that this data can be fed to some other backend (not necessarily supported by ZoKrates).
In order to produce the zkinterface from a circuit and some inputs do the following.

* Enter the nix-shell

```shell script
> nix-shell
[nix-shell: .../ZoKrates]$ 
```

* Compile the Zokrates binary 

```shell script
> cargo build --release

```

* Check the binary
```shell script
> $ZOKRATES_BIN generate-proof --help
zokrates-generate-proof 
Calculates a proof for a given constraint system and witness.

USAGE:
    zokrates generate-proof [OPTIONS]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
    -i, --input <FILE>             Path of the binary [default: out]
    -j, --proofpath <FILE>         Path of the JSON proof file [default: proof.json]
    -s, --proving-scheme <FILE>    Proving scheme to use for generating the proof. Available options are G16 (default),
                                   PGHR13, GM17 and zkinterface [default: g16]
    -p, --provingkey <FILE>        Path of the proving key file [default: proving.key]
    -w, --witness <FILE>           Path of the witness file [default: witness]
```

Note that *zkinterface* is available as a proving scheme.


In order to compile a circuit and generate the zkinterface data to be used by
some backend do the following: 

```shell script
> ./scripts/gen_zk_int_data_from_circuit.sh <path_to_circuit> <field_size> <inputs>
```

where
* `path_to_circuit` is the path to a file containing the description of a circuit.
*  `field_size` can take two options "BN" or "CURVE25519". BN128 must be picked if the 
backend uses some BN curve and CURVE25519 if the backend uses the Curve25519 curve.
* `inputs` contains the list of **public** inputs passed to the circuits.

Example:

```
> ./scripts/gen_zk_int_data_from_circuit.sh zokrates_cli/examples/add.zok BN 3

************************************************
* Generator of zkinterface data from circuit ***
************************************************
Public inputs: 3.
Path to circuit: zokrates_cli/examples/add.zok
Compiling zokrates_cli/examples/add.zok

field_size_str: 21888242871839275222246405745257275088548364400416034343698204186575808495617
Compiled program:
def main(_0) -> (1):
	(1 * ~one) * (28 * ~one + 10 * _0) == 1 * ~out_0
	 return ~out_0
Compiled code written to 'out'
Human readable code to 'out.ztf'
Number of constraints: 1
Performing setup...
field_size_str: 21888242871839275222246405745257275088548364400416034343698204186575808495617
def main(_0) -> (1):
	(1 * ~one) * (28 * ~one + 10 * _0) == 1 * ~out_0
	 return ~out_0
main_return_count:1

The R1CS file can be found at /tmp/zk_int_verifier.zik
Setup completed.
Computing witness...
field_size_str: 21888242871839275222246405745257275088548364400416034343698204186575808495617
def main(_0) -> (1):
	(1 * ~one) * (28 * ~one + 10 * _0) == 1 * ~out_0
	 return ~out_0

Witness: 

["58"]
Generating proof...
field_size_str: 21888242871839275222246405745257275088548364400416034343698204186575808495617
main_return_count:1

The witness file can be found at /tmp/zk_int_prover.zik
generate-proof successful: 
```

Finally the information containing the R1CS and the public inputs can be found at `/tmp/zk_int_verifier.zik`,
and the information containing the witness at `/tmp/zk_int_prover.zik`.
