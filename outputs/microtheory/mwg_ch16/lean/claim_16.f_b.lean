import Mathlib

theorem Claim_16F_b
    {I L J : ℕ}
    (u : Fin I → Fin L → ℝ → ℝ)
    (F : Fin J → Fin L → ℝ → ℝ)
    (x : Fin I → Fin L → ℝ)
    (y : Fin J → Fin L → ℝ)
    (δ : Fin I → ℝ)
    (μ : Fin L → ℝ)
    (γ : Fin J → ℝ)
    (hδ_nonneg : ∀ i, 0 ≤ δ i)
    (hμ_nonneg : ∀ ℓ, 0 ≤ μ ℓ)
    (hγ_nonneg : ∀ j, 0 ≤ γ j)
    (hKKT_consumer : ∀ i ℓ, δ i * u i ℓ (x i ℓ) - μ ℓ ≤ 0)
    (hKKT_compl : ∀ i ℓ, x i ℓ > 0 → δ i * u i ℓ (x i ℓ) - μ ℓ = 0)
    (hKKT_firm : ∀ j ℓ, μ ℓ - γ j * F j ℓ (y j ℓ) = 0) :
    (∀ i ℓ, δ i * u i ℓ (x i ℓ) - μ ℓ ≤ 0 ∧
             (x i ℓ > 0 → δ i * u i ℓ (x i ℓ) - μ ℓ = 0)) ∧
    (∀ j ℓ, μ ℓ = γ j * F j ℓ (y j ℓ)) := by
  exact ⟨fun i ℓ => ⟨hKKT_consumer i ℓ, hKKT_compl i ℓ⟩,
         fun j ℓ => by linarith [hKKT_firm j ℓ]⟩