import Mathlib

lemma expand_product_right_first {S : Type*} [Semiring S] (a b c d : S) : 
  (a + b) * (c + d) = a * c + a * d + b * c + b * d := by
  rw [right_distrib, left_distrib, left_distrib]
  rw [← add_assoc]