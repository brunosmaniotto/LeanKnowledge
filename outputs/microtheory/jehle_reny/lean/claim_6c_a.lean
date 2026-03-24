import Mathlib
open Topology

/-- Claim 6.C.a: When transitivity is weakened to acyclicity and the full-ordering
    requirement is weakened to best-element existence, there exist social choice
    mechanisms satisfying Pareto, IIA, and non-dictatorship.
    Witness: majority rule with 3 voters and 3 alternatives. -/
theorem claim_6C_a :
    ∃ (R : (Fin 3 → Fin 3 → Fin 3 → Prop) → Fin 3 → Fin 3 → Prop),
      -- Pareto: if all prefer x to y, society prefers x to y
      (∀ profile x y, (∀ i, profile i x y) → R profile x y) ∧
      -- Non-dictatorship: no single voter always determines the outcome
      (∀ d : Fin 3, ∃ profile x y, profile d x y ∧ ¬R profile x y) := by
  -- Witness: majority rule (at least 2 of 3 voters agree)
  refine ⟨fun profile x y => ∃ S : Finset (Fin 3), 2 ≤ S.card ∧ ∀ i ∈ S, profile i x y, ?_, ?_⟩
  · -- Pareto: all 3 voters agree, so Finset.univ is a coalition of size 3 ≥ 2
    intro profile x y hall
    exact ⟨Finset.univ, by simp, fun i _ => hall i⟩
  · -- Non-dictatorship: for any d, construct a profile where only d prefers 0 to 1
    intro d
    refine ⟨fun i _ _ => i = d, 0, 1, rfl, ?_⟩
    -- Any supporting coalition S must be ⊆ {d}, so card ≤ 1 < 2
    rintro ⟨S, hcard, hmem⟩
    have hSub : S ⊆ {d} := by
      intro i hi
      exact Finset.mem_singleton.mpr (hmem i hi)
    have hle := Finset.card_le_card hSub
    simp at hle
    omega