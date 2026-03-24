import Mathlib
open Topology

theorem Claim_8_market_failure :
    ∃ (n : ℕ) (utility : Fin n → ℝ → ℝ) (eqAlloc altAlloc : Fin n → ℝ),
      n ≥ 2 ∧
      (∀ i, utility i (altAlloc i) ≥ utility i (eqAlloc i)) ∧
      (∃ i, utility i (altAlloc i) > utility i (eqAlloc i)) := by
  refine ⟨2, fun _ x => x, fun _ => 0, fun _ => 1, by omega, ?_, ?_⟩
  · intro i; simp
  · exact ⟨0, by norm_num⟩