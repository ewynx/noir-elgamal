use dep::std;
use dep::std::collections::vec::Vec;

// Given generator gen, public key pub_key, message m and randomness r
// Output ciphertext (c1,c2)
// c1 = gen^r
// c2 = genˆm * pub_key^r
// The difference is genˆm instead of m for "standard" ElGamal
fn single_hom_encryption_fe(
  gen: Field, 
  pub_key: Field, 
  m: Field, 
  r: Field) -> (Field, Field) {

  let c1 = gen.pow_32(r);
  let temp1 = pub_key.pow_32(r);
  let temp2 = gen.pow_32(m) ;
  let c2 = temp2 * temp1;
  (c1, c2)
}

// Multiplying the ciphertext equals adding underlying plaintexts
fn homomorphic_operation_fe(
  c1_1: Field, 
  c2_1: Field,
  c1_2: Field, 
  c2_2: Field) -> (Field, Field) {
  // If (c1_1, c2_1) = enc(gen, pub_key, m1, r1) and (c1_2, c2_2) = enc(gen, pub_key, m2, r2)
  // Then: 
  // c1_1*c1_2 = genˆr1 * genˆr2 = genˆ{r1+r2}
  // c1_2*c2_2 = genˆm1 * pub_key^r1 * genˆm2 * pub_key^r2
  // Which equals the encryption of the plaintexts, added
  // enc(gen, pub_key, m1+m2, r1+r2) = (genˆ{r1+r2}, genˆ{m1+m2} * pub_key^{r1+r2})
  (c1_1*c1_2, c2_1*c2_2)
}

// Perform homomorphic operation on vector of ciphertexts, 
//   resulting into a single ciphertext which equals the encryption of the addition of all plaintexts
fn homomorphic_operation_fe_vec(c1: Vec<Field>, c2: Vec<Field>) -> (Field, Field) {

  // Apparently the vec needs to be mutable to access elements
  let mut t1 = c1;
  let mut t2 = c2;

  let mut updated_c_1 = t1.get(0);
  let mut updated_c_2 = t2.get(0);

  for i in 1..c1.len() {
    let (r1,r2) = homomorphic_operation_fe(t1.get(i), t2.get(i), updated_c_1, updated_c_2);
    updated_c_1 = r1;
    updated_c_2 = r2;
  }
    
  // If I don't add this step, return type doesn't get recognized
  let res1: Field = updated_c_1;
  let res2: Field = updated_c_2;
  (res1, res2)
}
