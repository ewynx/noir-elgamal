# Homomorphic encryption in Noir

*Prove that the ciphertext you're providing is the addition of 2 (or more) plaintexts*

## ElGamal

The [ElGamal system](https://en.wikipedia.org/wiki/ElGamal_encryption) is a public-key cryptosystem. One of its remarkable features is that it allows for either homomorphic addition or multiplication, which means that manipulation on the ciphertext can correspond directly to manipulation on the plaintext. 

Example: multiplying ciphertext gives the same result as encrypting the added plaintexts:

```Enc(m1,r1) * Enc(m2,r2) EQUALS Enc(m1+m2, r1+r2)```

## Noir

This implementation is built on [Noir](https://noir-lang.org/) `0.10.0`. 

Find great resources, in addition to the official documentation, [here](https://github.com/noir-lang/awesome-noir).

Noir has an intrinsic Field element, which is of bn254. This means all field operations are performed mod 

## Usecases of homomorphic operations in ZKP

This simple example of using homomorphic encryption within ZKP can be used in different scenarios, for example: 
- secure computing outsourcing: the third party can add a proof that data has been added correctly
- when casting votes, add this as an additional proof that you have casted the correct amount of votes
- for transactions, prove that you have the funds to make the transaction by adding 2 or more UTXOs without revealing which ones they are and what addresses are involved
- in gaming: prove posession of certain in-game assets without revealing any further details/history

## This repo

Consists of 
- a library with ElGamal (field) functionalities
- examples of circuits that use the ElGamal functionalities

Most, notably the `hom_addition` circuit, which generates a proof that a ciphertext is the encryption of 2 messages added together. 

## Open issues

- for the homomorphic operation, it fails when m1,m2,r1,r2 combined are too large. Could this be caused by the pow_32 function?
- testing the hom_addition circuit passes with the in-file test, but using the same values in `Prover.toml` gives the error `Error: could not satisfy all constraints`. 