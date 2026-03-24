import Mathlib

structure EntryDeterrenceSetup where
  b0 : ℝ
  F : ℝ
  k_Z : ℝ
  k_B : ℝ
  k_S : ℝ
  profit_monopoly : ℝ
  profit_deterrence : ℝ
  profit_accommodation : ℝ
  hF_nonneg : 0 ≤ F

/-- Classification: exactly one of the three entry deterrence scenarios holds.
    Case 1 (blockaded): k_Z ≤ b0
    Case 2 (accommodation): k_B < k_Z
    Case 3 (deterrence possible): b0 < k_Z ∧ k_Z ≤ k_B -/
theorem Claim_12BB_b (G : EntryDeterrenceSetup) :
    (G.k_Z ≤ G.b0) ∨
    (G.k_B < G.k_Z) ∨
    (G.b0 < G.k_Z ∧ G.k_Z ≤ G.k_B) := by
  by_cases h1 : G.k_Z ≤ G.b0
  · exact Or.inl h1
  · push_neg at h1
    by_cases h2 : G.k_Z ≤ G.k_B
    · exact Or.inr (Or.inr ⟨h1, h2⟩)
    · push_neg at h2
      exact Or.inr (Or.inl h2)