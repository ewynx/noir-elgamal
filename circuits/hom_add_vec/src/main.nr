use dep::lib::elgamal::homomorphic_fe::{single_hom_encryption_fe, homomorphic_operation_fe_vec};
use dep::std::collections::vec::Vec;

// Proves that I have a ciphertext of the addition of 4 messages
// The underlying functionality can handle arbitrary sized input, but the input of the circuit must have fixed size
// "Message:  Cannot have variable sized arrays as a parameter to main"
fn main(
  gen: pub Field,
  pub_key: pub Field,
  r: [Field; 4],
  m: [Field; 4],
  ciphertext_1: pub Field, 
  ciphertext_2: pub Field
) {
  // Create all ciphertexts
  // (genˆr1, m1 * pub_key^r1)
  let (d1, d2) = single_hom_encryption_fe(gen, pub_key, m[0], r[0]);
  // (genˆr2, m2 * pub_key^r2)
  let (e1, e2) = single_hom_encryption_fe(gen, pub_key, m[1], r[1]);
  let (f1, f2) = single_hom_encryption_fe(gen, pub_key, m[2], r[2]);
  let (g1, g2) = single_hom_encryption_fe(gen, pub_key, m[3], r[3]);

  // // Perform the homomorphic operation, which should translate to addition on the plaintexts
  // // genˆr1 * genˆr2 = genˆ{r1+r2}
  // // genˆm1 * pub_key^r1 * genˆm2 * pub_key^r2
  let mut c1: Vec<Field> = Vec::new();
  let mut c2: Vec<Field> = Vec::new();
  c1.push(d1);
  c1.push(e1);
  c1.push(f1);
  c1.push(g1);
  c2.push(d2);
  c2.push(e2);
  c2.push(f2);
  c2.push(g2);
  let (added1, added2) = homomorphic_operation_fe_vec(c1, c2);

  assert(added1 == ciphertext_1);
  assert(added2 == ciphertext_2);
}