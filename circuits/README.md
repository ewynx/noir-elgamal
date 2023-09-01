# ElGamal in Noir

```
nargo --version
nargo 0.10.0 (git version hash: 0508378345bfdad4b44f1b82aae203b16a24af9c, is dirty: false)
```

## Noir Build & Run

Compile: 
```
nargo check
```
This should generate `Prover.toml` and `Verifier.toml`.


Fill needed values in Prover.toml and create proof:
```
nargo prove
```

Run tests:
```
nargo test
```

Test with logging:
```
nargo test --show-output
```

Add logging to code like this:
```
use dep::std;
std::println("test");
```


## Pari/GP

Check intermediate values and valid elements using [Pari/GP](https://pari.math.u-bordeaux.fr/).

BN254 field prime = 21888242871839275222246405745257275088548364400416034343698204186575808495617.

Get random element in field:
```
random(21888242871839275222246405745257275088548364400416034343698204186575808495617)
```

Check multiplicative inverse of x:
```
Mod(1/x, 21888242871839275222246405745257275088548364400416034343698204186575808495617)
```

Also, check that it's correct verifying that this gives output 1 for x_inv:
```
Mod(x_inv*x, 21888242871839275222246405745257275088548364400416034343698204186575808495617)
```

Convert decimal to hex:
```
printf("%x", val)
```
