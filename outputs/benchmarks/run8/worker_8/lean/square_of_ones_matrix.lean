import Mathlib

open Matrix BigOperators Finset

theorem Square_of_Ones_Matrix (n : ℕ) (R : Type*) [CommSemiring R] :
  let J : Matrix (Fin n) (Fin n) R := fun _ _ => 1
  J ^ 2 = (n : R) • J := by
  ext i j
  simp [pow_two, mul_apply, smul_apply, sum_const, card_univ, Fintype.card_fin, nsmul_one, mul_one]