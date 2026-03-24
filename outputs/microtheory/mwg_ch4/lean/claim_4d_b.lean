import Mathlib

open Finset BigOperators
open BigOperators

theorem Claim_4D_b
    {J : ℕ} (a : Fin J → ℝ) (b : ℝ) (w : Fin J → ℝ) :
    (∑ i : Fin J, (a i + b * w i)) = (∑ i : Fin J, a i) + b * (∑ i : Fin J, w i) := by
  simp [Finset.sum_add_distrib, Finset.mul_sum]