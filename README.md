
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

* Compile a circuit

```shell script
> $ZOKRATES_BIN compile -i <path_to_circuit>

```

* Run the setup using *zkinterface* as a proving scheme.

```shell script
> $ZOKRATES_BIN setup -s zkinterface

```

* Compute the witness

```shell script
> $ZOKRATES_BIN compute-witness -a 1 2

```

Recall that argument passed to the circuit come after the "-a" option.

* Generate the proof using zkinterface as a proving scheme 
(indeed in our case only some intermediary information containing the R1CS + witness will be computed).
The actual proof will be obtained by some other backend.

```shell script
> $ZOKRATES_BIN generate-proof -s zkinterface
```

* The intermediary representation for the **r1cs** computed by zkinterface can be found at `/tmp/zk_int_r1cs`.
* The intermediary representation for the **witness** computed by zkinterface can be found at `/tmp/zk_int_witness`.
