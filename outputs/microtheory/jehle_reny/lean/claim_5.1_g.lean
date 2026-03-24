import Mathlib

open Finset BigOperators
open BigOperators

/-- If x ∈ F(e) is unblocked, then x is Pareto efficient, because otherwise
    it would be blocked by the grand coalition S = I. -/
theorem Claim_5_1_g
    {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]
    {L : ℕ}
    (u : I → (Fin L → ℝ) → ℝ)
    (e x : I → Fin L → ℝ)
    (hfeas : ∀ l, ∑ i, x i l = ∑ i, e i l)
    (hunblocked : ¬∃ S : Finset I, S.Nonempty ∧ ∃ y : I → Fin L → ℝ,
        (∀ l, ∑ i ∈ S, y i l = ∑ i ∈ S, e i l) ∧
        (∀ i ∈ S, u i (y i) ≥ u i (x i)) ∧
        ∃ i ∈ S, u i (y i) > u i (x i)) :
    ¬∃ y : I → Fin L → ℝ, (∀ l, ∑ i, y i l = ∑ i, e i l) ∧
      (∀ i, u i (y i) ≥ u i (x i)) ∧ ∃ i, u i (y i) > u i (x i) := by
  rintro ⟨y, hy_feas, hy_weak, j, hj⟩
  exact hunblocked ⟨univ, univ_nonempty, y, hy_feas, fun i _ => hy_weak i, j, mem_univ j, hj⟩