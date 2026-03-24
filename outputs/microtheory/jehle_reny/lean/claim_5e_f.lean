import Mathlib

open Finset BigOperators
open BigOperators

theorem claim_5e_f {I : ℕ} {x e : Fin I → ℝ} {r : ℝ} (hr : r ≠ 0)
    (h_feasible_r : r * ∑ i, x i = r * ∑ i, e i) :
    ∑ i, x i = ∑ i, e i := by
  exact mul_left_cancel₀ hr h_feasible_r