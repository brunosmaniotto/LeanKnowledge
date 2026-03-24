import Mathlib

/-- An equilibrium (p₁*, p₂*) of a two-commodity tâtonnement process.
    `trajectory` maps an initial price vector (p₁, p₂) and time t to the price vector at time t.
    `LocallyStable`: relative prices converge to p₁*/p₂* for initial prices sufficiently close.
    `LocallyTotallyUnstable`: any perturbation causes relative prices to diverge from p₁*/p₂*. -/
structure TatonnementStability
    (p_star : Fin 2 → ℝ)
    (trajectory : (Fin 2 → ℝ) → ℝ → (Fin 2 → ℝ)) where
  /-- p₂* is positive so relative price p₁*/p₂* is well-defined -/
  h_pos : p_star 1 > 0
  /-- Locally stable: for initial prices sufficiently close to p*, the relative price
      trajectory(p₀, t)₀ / trajectory(p₀, t)₁ converges to p₁*/p₂* as t → ∞ -/
  locallyStable : Prop :=
    ∀ ε > 0, ∃ δ > 0, ∀ p₀ : Fin 2 → ℝ,
      (∀ i, |p₀ i - p_star i| < δ) →
        ∀ η > 0, ∃ T : ℝ, ∀ t, t > T →
          trajectory p₀ t 1 > 0 ∧
          |trajectory p₀ t 0 / trajectory p₀ t 1 - p_star 0 / p_star 1| < η
  /-- Locally totally unstable: any perturbation from p* causes relative prices to diverge -/
  locallyTotallyUnstable : Prop :=
    ∀ p₀ : Fin 2 → ℝ, p₀ ≠ p_star →
      ¬(∀ η > 0, ∃ T : ℝ, ∀ t, t > T →
        trajectory p₀ t 1 > 0 ∧
        |trajectory p₀ t 0 / trajectory p₀ t 1 - p_star 0 / p_star 1| < η)