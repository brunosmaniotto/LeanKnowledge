import Mathlib

theorem investment_effect_on_rival_equilibrium
    (db₁_dk : ℝ)
    (db₁_ds₂ : ℝ)
    (db₂_ds₁ : ℝ)
    (hstab : 1 - db₁_ds₂ * db₂_ds₁ ≠ 0)
    : ∃ ds₂_dk : ℝ,
        ds₂_dk = (db₁_dk * db₂_ds₁) / (1 - db₁_ds₂ * db₂_ds₁) ∧
        ds₂_dk * (1 - db₁_ds₂ * db₂_ds₁) = db₁_dk * db₂_ds₁ := by
  exact ⟨(db₁_dk * db₂_ds₁) / (1 - db₁_ds₂ * db₂_ds₁), rfl,
    div_mul_cancel₀ _ hstab⟩