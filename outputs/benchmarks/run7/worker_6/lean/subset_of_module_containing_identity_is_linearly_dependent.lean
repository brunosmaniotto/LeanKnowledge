import Mathlib

open Set

theorem subset_containing_zero_is_lin_dep {R G : Type*} [Ring R] [Nontrivial R] [AddCommGroup G] [Module R G]
    (H : Set G) (hH : (0 : G) ∈ H) : ¬ LinearIndependent R (fun x : H => (x : G)) := by
  intro h_ind
  have := h_ind.ne_zero ⟨0, hH⟩
  simp at this