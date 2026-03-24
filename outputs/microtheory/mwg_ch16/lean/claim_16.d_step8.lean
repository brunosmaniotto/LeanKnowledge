import Mathlib

open BigOperators Finset
open Topology

variable {n : ℕ}

/-- If p · (x_i + sum_others) ≥ p · (x_star_i + sum_others), then p · x_i ≥ p · x_star_i. -/
theorem Claim_16D_step8
    (p x_i x_star_i sum_others : Fin n → ℝ)
    (hpref : ∑ j, p j * (x_i j + sum_others j) ≥ ∑ j, p j * (x_star_i j + sum_others j)) :
    ∑ j, p j * x_i j ≥ ∑ j, p j * x_star_i j := by
  have : ∑ j, p j * (x_i j + sum_others j) = ∑ j, (p j * x_i j + p j * sum_others j) := by
    congr 1; ext j; ring
  have : ∑ j, p j * (x_star_i j + sum_others j) = ∑ j, (p j * x_star_i j + p j * sum_others j) := by
    congr 1; ext j; ring
  simp only [Finset.sum_add_distrib] at *
  linarith