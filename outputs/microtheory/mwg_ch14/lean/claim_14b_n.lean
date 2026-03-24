import Mathlib

theorem optimal_compensation_independent_of_noisy_signal
    {ProfitSpace SignalSpace : Type*} [Nonempty ProfitSpace] [Nonempty SignalSpace]
    (f₁_H f₁_L : ProfitSpace → ℝ)
    (f₂ : SignalSpace → ℝ)
    (hf₂_pos : ∀ y, 0 < f₂ y)
    : ∀ (π : ProfitSpace) (y₁ y₂ : SignalSpace),
        f₁_H π * f₂ y₁ / (f₁_L π * f₂ y₁) = f₁_H π * f₂ y₂ / (f₁_L π * f₂ y₂) := by
  intro π y₁ y₂
  have h₁ := hf₂_pos y₁
  have h₂ := hf₂_pos y₂
  by_cases hL : f₁_L π = 0
  · simp [hL]
  · have hd₁ : f₁_L π * f₂ y₁ ≠ 0 := mul_ne_zero hL (ne_of_gt h₁)
    have hd₂ : f₁_L π * f₂ y₂ ≠ 0 := mul_ne_zero hL (ne_of_gt h₂)
    field_simp