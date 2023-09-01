use dep::lib::elgamal::homomorphic_fe::{single_hom_encryption_fe, homomorphic_operation_fe};
use dep::std;

// Proves that I have a ciphertext of the addition of 2 messages
// Private inputs: m1,m2,r1,r2 (messages and their corresponding randomnesses for encryption)
// Public inputs: generator, public key under which encryption was done, ciphertext that we're proving for
fn main(
  gen: pub Field,
  pub_key: pub Field,
  r1: Field,
  m1: Field,
  r2: Field, 
  m2: Field,
  ciphertext_1: pub Field, 
  ciphertext_2: pub Field
) {
  // Create both ciphertexts
  // (genˆr1, m1 * pub_key^r1)
  let (d1, d2) = single_hom_encryption_fe(gen, pub_key, m1, r1);
  // (genˆr2, m2 * pub_key^r2)
  let (e1, e2) = single_hom_encryption_fe(gen, pub_key, m2, r2);

  // Perform the homomorphic operation, which should translate to addition on the plaintexts
  // genˆr1 * genˆr2 = genˆ{r1+r2}
  // genˆm1 * pub_key^r1 * genˆm2 * pub_key^r2
  let (added1, added2) = homomorphic_operation_fe(d1, d2, e1, e2);

  assert(added1 == ciphertext_1);
  assert(added2 == ciphertext_2);
}

#[test]
fn test_main_1() {
  // priv key
  let x = 7115637666404682632379307215493662218327241124760828634863089038725962038957;
  
  // gen = 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9fd2c88d0
  let gen = 10944121435919637611123202872628637544274182200208017171849102093287991052496;
  
  // pub_key = gen^x
  let pub_key = gen.pow_32(x);
  std::println(pub_key); // 0x06c4dfa71f2a7a8810dc34ce86938764a51b6bf5bce71da90c1c5fc9407e0ebc

  let msg1 = 1111;
  let msg2 = 2222;

  // TODO It only works if the 2 randomnessess together aren't too big it seems.
  let randomness1 = 18781456255357152124930966365016094019362299655621530163902908874136078409517;
  // doesn't work
  // let randomness2 = 16691817043247903474315859400317678937424095611113194787133324833622392219635;
  // works...
  let randomness2 = 1234;

  let combined_msg = msg1+msg2;
  let combined_randomness = randomness1 + randomness2;
  let (c1, c2) = single_hom_encryption_fe(gen, pub_key, combined_msg, combined_randomness);
  std::println(c1); // 0x28f0bc9519eb25c9e5d87a7aabfb14e3f41ae49d713eb1733ac2eca419187273
  std::println(c2); // 0x1259909371844412078bdf92a226e2662ffcb60ea17b89576eaf231a9e007571

  main(gen,
    pub_key,
    randomness1,
    msg1,
    randomness2,
    msg2,
    c1,
    c2);
}