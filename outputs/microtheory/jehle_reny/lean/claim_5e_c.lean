import Mathlib

open BigOperators Finset
open Topology

/-- An allocation x in the r-replica economy E_r is feasible if and only if
    the total consumption equals r times the total endowment. -/
theorem Claim_5e_c
    {I : Type*} [Fintype I] [DecidableEq I]
    {L : Type*} [Fintype L] [DecidableEq L]
    (r : ℕ)
    (e : I → (L → ℝ))
    (x : I → Fin r → (L → ℝ)) :
    (∑ i : I, ∑ q : Fin r, x i q = ∑ i : I, ∑ _q : Fin r, e i) ↔
    (∑ i : I, ∑ q : Fin r, x i q = r • ∑ i : I, e i) := by
  suffices h : ∑ i : I, ∑ _q : Fin r, e i = r • ∑ i : I, e i by
    constructor <;> intro heq <;> rw [heq] <;> [rw [h]; rw [← h]]
  simp [Finset.sum_const, Finset.card_fin, smul_sum]