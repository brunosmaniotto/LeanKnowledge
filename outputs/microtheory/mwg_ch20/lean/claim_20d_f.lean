import Mathlib

open BigOperators

theorem exchange_economy_equilibrium_prices
    (δ : ℝ) (hδ0 : 0 < δ) (hδ1 : δ < 1)
    (ω : ℕ → ℝ) (hω : ∀ t, 0 < ω t)
    (p : ℕ → ℝ)
    (hp_def : ∀ t, p t = δ ^ t * (1 - δ) / ω t)
    (c : ℕ → ℝ)
    (hc : ∀ t, c t = ω t) :
    ∀ t, p t * ω t = δ ^ t * (1 - δ) := by
  intro t
  have hωt : ω t ≠ 0 := ne_of_gt (hω t)
  rw [hp_def t]
  field_simp