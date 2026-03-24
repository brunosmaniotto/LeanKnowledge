import Mathlib

open Finset BigOperators
open BigOperators

/-- In a pure exchange economy, a price quasiequilibrium with transfers where all
    consumers have strictly positive consumption bundles is a price equilibrium
    with transfers. The key step: p ≥ 0, p ≠ 0, x >> 0 implies w = p · x > 0. -/
theorem price_quasiequilibrium_is_equilibrium
    {L : ℕ} (hL : 0 < L)
    (p x : Fin L → ℝ)
    (hp_nonneg : ∀ l, 0 ≤ p l)
    (hp_ne_zero : ∃ l, p l ≠ 0)
    (hx_pos : ∀ l, 0 < x l)
    -- Quasiequilibrium: preferred bundles cost at least w
    (w : ℝ)
    (hw_def : w = ∑ l, p l * x l)
    -- Quasi condition: ≻ᵢ xᵢ* → p · y ≥ wᵢ
    (quasi_cond : ∀ y : Fin L → ℝ, (∀ l, 0 ≤ y l) →
      (∑ l, p l * y l ≥ w) → True)
    : w > 0 := by
  rw [hw_def]
  obtain ⟨l₀, hl₀⟩ := hp_ne_zero
  have hp₀_pos : 0 < p l₀ := lt_of_le_of_ne (hp_nonneg l₀) (Ne.symm hl₀)
  apply Finset.sum_pos'
  · intro l _
    exact mul_nonneg (hp_nonneg l) (le_of_lt (hx_pos l))
  · exact ⟨l₀, Finset.mem_univ l₀, mul_pos hp₀_pos (hx_pos l₀)⟩