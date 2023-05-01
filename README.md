# We need financial support to continue development.  Please [become a sponsor](https://opencollective.com/cotowali).


<div align="center">
  <img width="200" src="https://raw.githubusercontent.com/cotowali/design/main/assets/cotowali.svg?sanitize=true">
  <h1>Cotowali</h1>
  <p>A statically typed scripting language that transpile into POSIX sh</p>
  <p><a href="https://cotowali.org/" ref="nofollow" target="_blank">Website</a></p>
  <p>
    <a href="http://mozilla.org/MPL/2.0/" rel="nofollow">
      <img  alt="License: MPL 2.0" src="https://img.shields.io/badge/License-MPL%202.0-blue.svg?style=flat-square">
    <a href="https://discord.com/invite/nwEad5dNYg" rel="nofollow">
      <img alt="Join Cotowali Discord" src=https://img.shields.io/static/v1?label=Discord&logo=discord&logoColor=white&message=Join&color=&style=flat-square
    </a>
  </p>
</div>

## Concepts of Cotowali

- Outputs shell script that is fully compliant with POSIX standards.
- Simple syntax.
- Simple static type system.
- Syntax for shell specific feature like pipe and redirection.

## Example

```v
fn fib(n: int): int {
  if n < 2 {
    return n
  }
  return fib(n - 1) + fib(n - 2)
}

fn int |> twice() |> int {
   var n = 0
   read(&n)
   return n * 2
}

assert(fib(6) == 8)
assert((fib(6) |> twice()) == 16)

fn ...int |> sum() |> int {
  var v: int
  var res = 0
  while read(&v) {
    res += v
  }
  return res
}

fn ...int |> twice_each() |> ...int {
  var n: int
  while read(&n) {
    yield n * 2
  }
}

assert((seq(3) |> sum()) == 6)
assert((seq(3) |> twice_each() |> sum()) == 12)

// Call command by `@command` syntax with pipeline operator
assert(((1, 2) |> @awk('{print $1 + $2}')) == '3')
```

[There are more examples](./examples)

## Installation

### Use [Konryu](https://github.com/cotowali/konryu) (cotowali installer written in cotowali)

```sh
curl -sSL https://konryu.cotowali.org | sh
# add to your shell config like .bashrc
export PATH="$HOME/.konryu/bin:$PATH"
eval "$(konryu init)"
```

### Build from source

0. Install required tools

    - [The V Programming Language](https://github.com/vlang/v)
        ```sh
        git clone https://github.com/vlang/v
        cd v
        make
        ```

    - [zakuro9715/z](https://github.com/zakuro9715/z)
        ```sh
        go install github.com/zakuro9715/z
        # or
        curl -sSL gobinaries.com/zakuro9715/z | sh
        ```

1. Build

    ```sh
    z build
    ```

2. Install

    ```sh
    sudo z symlink
    # or
    sudo z install
    ```

## How to use

```sh
# compile
lic examples/add.li

# execution
lic examples/add.li | sh
# or
lic run examples/add.li
```

## Development

See [docs/development.md](./docs/development.md)

### Docker

```
docker compose run dev
```

## Author

[zakuro](https://twitter.com/zakuro9715) &lt;z@kuro.red&gt;

## Acknowledgements

Cotowali is supported by 2021 Exploratory IT Human Resources Project ([The MITOU Program](https://www.ipa.go.jp/en/it-talents/mitou.html) by IPA: Information-technology Promotion Agency, Japan).
