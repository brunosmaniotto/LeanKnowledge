import Mathlib
open Topology

theorem Claim_2_4_c
    {Outcome : Type*} (pref : Outcome → Outcome → Prop)
    (a₁ aₙ : Outcome)
    (lottery : ℝ → ℝ → Outcome → Outcome → Outcome)
    (h_lot_1_0 : lottery 1 0 a₁ aₙ = a₁)
    (h_lot_0_1 : lottery 0 1 a₁ aₙ = aₙ)
    (monotonicity : ∀ α β : ℝ, 0 ≤ α → α ≤ 1 → 0 ≤ β → β ≤ 1 →
      α > β → pref (lottery α (1 - α) a₁ aₙ) (lottery β (1 - β) a₁ aₙ))
    : pref a₁ aₙ := by
  have h := monotonicity 1 0 (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  simp only [sub_self, sub_zero] at h
  rwa [h_lot_1_0, h_lot_0_1] at h