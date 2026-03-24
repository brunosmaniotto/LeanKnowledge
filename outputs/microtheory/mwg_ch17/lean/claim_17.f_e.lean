import Mathlib

theorem excess_demand_decreases
    {L : ℕ}
    (z : (Fin L → ℝ) → Fin L → ℝ)
    (hHom : ∀ (p : Fin L → ℝ) (α : ℝ), α > 0 → z (fun i => α * p i) = z p)
    (hGS : ∀ (q q' : Fin L → ℝ) (ℓ : Fin L),
      q' ℓ = q ℓ → (∀ k, q' k ≤ q k) → (∃ k, k ≠ ℓ ∧ q' k < q k) →
      z q' ℓ < z q ℓ)
    (p p' : Fin L → ℝ) (ℓ : Fin L)
    (hp_pos : ∀ i, p i > 0)
    (hL : L ≥ 2)
    (hℓ : p' ℓ > p ℓ)
    (hk : ∀ k, k ≠ ℓ → p' k = p k) :
    z p' ℓ < z p ℓ := by
  let α := p' ℓ / p ℓ
  have hpℓ_pos : p ℓ > 0 := hp_pos ℓ
  have hpℓ_ne : p ℓ ≠ 0 := ne_of_gt hpℓ_pos
  have hα_pos : α > 0 := div_pos (lt_trans hpℓ_pos hℓ) hpℓ_pos
  have hα_gt : α > 1 := (one_lt_div hpℓ_pos).mpr hℓ
  let ptilde : Fin L → ℝ := fun i => α * p i
  have hzpt : z ptilde = z p := hHom p α hα_pos
  have hptℓ : ptilde ℓ = p' ℓ := by
    show α * p ℓ = p' ℓ
    exact div_mul_cancel₀ (p' ℓ) hpℓ_ne
  have hpt_ge : ∀ k, p' k ≤ ptilde k := by
    intro k
    by_cases hke : k = ℓ
    · rw [hke, hptℓ]
    · show p' k ≤ α * p k
      rw [hk k hke]
      have : p k > 0 := hp_pos k
      nlinarith
  have hpt_strict : ∃ k, k ≠ ℓ ∧ p' k < ptilde k := by
    rcases ℓ with ⟨j, hj⟩
    by_cases hj0 : j = 0
    · refine ⟨⟨1, by omega⟩, ?_, ?_⟩
      · simp [Fin.ext_iff]; omega
      · have hke : (⟨1, by omega⟩ : Fin L) ≠ ⟨j, hj⟩ := by simp [Fin.ext_iff]; omega
        show p' ⟨1, _⟩ < α * p ⟨1, _⟩
        rw [hk _ hke]
        have := hp_pos ⟨1, by omega⟩
        nlinarith
    · refine ⟨⟨0, by omega⟩, ?_, ?_⟩
      · simp [Fin.ext_iff]; omega
      · have hke : (⟨0, by omega⟩ : Fin L) ≠ ⟨j, hj⟩ := by simp [Fin.ext_iff]; omega
        show p' ⟨0, _⟩ < α * p ⟨0, _⟩
        rw [hk _ hke]
        have := hp_pos ⟨0, by omega⟩
        nlinarith
  calc z p' ℓ < z ptilde ℓ := hGS ptilde p' ℓ hptℓ.symm hpt_ge hpt_strict
    _ = z p ℓ := by rw [show z ptilde = z p from hzpt]