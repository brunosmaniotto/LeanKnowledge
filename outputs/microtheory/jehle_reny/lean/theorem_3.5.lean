import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

/-- Theorem 3.5: The recovered production function f(x) = sup{y ≥ 0 | w·x ≥ c(w,y) ∀w ≫ 0}
    is increasing. Key step: if x' ≥ x componentwise and w ≫ 0, then w·x' ≥ w·x ≥ c(w,y). -/
theorem theorem_3_5_monotone
    {c : (Fin n → ℝ) → ℝ → ℝ} {x x' : Fin n → ℝ} {y : ℝ} {w : Fin n → ℝ}
    (hw : ∀ i, 0 < w i) (hx : ∀ i, x i ≤ x' i)
    (hfeas : ∑ i : Fin n, w i * x i ≥ c w y) :
    ∑ i : Fin n, w i * x' i ≥ c w y := by
  calc c w y ≤ ∑ i : Fin n, w i * x i := hfeas
    _ ≤ ∑ i : Fin n, w i * x' i :=
        Finset.sum_le_sum fun i _ => mul_le_mul_of_nonneg_left (hx i) (le_of_lt (hw i))