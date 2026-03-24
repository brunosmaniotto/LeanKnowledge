import Mathlib

open BigOperators
open Topology

/-- Aggregate consumer surplus approximates total WTP for a price decrease,
    but gives no information about its distribution among consumers. -/
theorem Claim_4_3_1_h :
    ∀ (total : ℝ) (ht : 0 < total),
    ∃ (d1 d2 : Fin 2 → ℝ),
      (∑ i, d1 i = total) ∧
      (∑ i, d2 i = total) ∧
      d1 ≠ d2 := by
  intro total ht
  refine ⟨fun i => if i = 0 then total else 0,
          fun i => if i = 0 then 0 else total, ?_, ?_, ?_⟩
  · simp [Fin.sum_univ_two]
  · simp [Fin.sum_univ_two]
  · intro h
    have := congr_fun h 0
    simp at this
    linarith