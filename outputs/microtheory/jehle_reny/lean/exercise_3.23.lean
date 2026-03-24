import Mathlib

open BigOperators

noncomputable section

theorem Exercise_3_23
    {L : ℕ} {S : Set (Fin L → ℝ)}
    (hne : S.Nonempty)
    (c : (Fin L → ℝ) → ℝ)
    (hc : ∀ w : Fin L → ℝ, c w = sInf ((fun z => ∑ i : Fin L, w i * z i) '' S))
    (hbdd : ∀ w : Fin L → ℝ, BddBelow ((fun z => ∑ i : Fin L, w i * z i) '' S))
    (w₁ w₂ : Fin L → ℝ) :
    c w₁ + c w₂ ≤ c (w₁ + w₂) := by
  rw [hc w₁, hc w₂, hc (w₁ + w₂)]
  apply le_csInf (hne.image _)
  rintro _ ⟨z, hz, rfl⟩
  have h₁ : sInf ((fun z => ∑ i, w₁ i * z i) '' S) ≤ ∑ i, w₁ i * z i :=
    csInf_le (hbdd w₁) ⟨z, hz, rfl⟩
  have h₂ : sInf ((fun z => ∑ i, w₂ i * z i) '' S) ≤ ∑ i, w₂ i * z i :=
    csInf_le (hbdd w₂) ⟨z, hz, rfl⟩
  have heq : ∑ i : Fin L, (w₁ + w₂) i * z i = (∑ i, w₁ i * z i) + ∑ i, w₂ i * z i := by
    simp_rw [Pi.add_apply, add_mul]
    exact Finset.sum_add_distrib
  linarith