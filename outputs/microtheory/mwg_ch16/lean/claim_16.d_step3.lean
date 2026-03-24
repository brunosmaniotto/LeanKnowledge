import Mathlib

open Pointwise

universe u

theorem Claim_16D_step3
    {E : Type u} [AddCommGroup E]
    (V Y : Set E) (ω : E)
    (pareto_optimal : ∀ v ∈ V, v ∉ (Y + ({ω} : Set E))) :
    V ∩ (Y + ({ω} : Set E)) = ∅ := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_empty_iff_false, iff_false, not_and]
  intro hx
  exact pareto_optimal x hx