import Mathlib

variable {U : Type _} [Preorder U]

theorem inf_le_inf_of_subset {S T : Set U} {a b : U}
    (hS : IsGLB S a) (hT : IsGLB T b) (h : T ⊆ S) : a ≤ b := by
  -- `a` is a lower bound for `S`, so for any `x ∈ T` (which is in `S`), we have `a ≤ x`
  have h_a_lb_T : a ∈ lowerBounds T := by
    intro x hx
    exact hS.1 (h hx)
  -- Since `b` is the greatest lower bound for `T`, and `a` is a lower bound for `T`, we have `a ≤ b`
  exact hT.2 h_a_lb_T