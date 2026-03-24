import Mathlib

-- Axiomatize the social choice framework
variable {X I : Type*} [DecidableEq X]

axiom Decisive : Set I → X → X → Prop

axiom step1_decisive_xz : ∀ (S : Set I) (x y z : X),
  x ≠ y → x ≠ z → y ≠ z → Decisive S x y → Decisive S x z

axiom step1_decisive_zy : ∀ (S : Set I) (x y z : X),
  x ≠ y → x ≠ z → y ≠ z → Decisive S x y → Decisive S z y

theorem Claim_21C_Step2
    (S : Set I) (x y z w : X)
    (hxy : x ≠ y) (hxz : x ≠ z) (hyz : y ≠ z)
    (hzw : z ≠ w) (hxw : x ≠ w) (hyw : y ≠ w)
    (hS : Decisive S x y) :
    Decisive S z w ∧ Decisive S w z := by
  have hzy_dec : Decisive S z y := step1_decisive_zy S x y z hxy hxz hyz hS
  have hxz_dec : Decisive S x z := step1_decisive_xz S x y z hxy hxz hyz hS
  constructor
  · -- S decisive for z over y → S decisive for z over w (Step 1 on {z,y} with third alt w)
    exact step1_decisive_xz S z y w (Ne.symm hyz) hzw hyw hzy_dec
  · -- S decisive for x over z → S decisive for w over z (Step 1 on {x,z} with third alt w)
    exact step1_decisive_zy S x z w hxz hxw hzw hxz_dec