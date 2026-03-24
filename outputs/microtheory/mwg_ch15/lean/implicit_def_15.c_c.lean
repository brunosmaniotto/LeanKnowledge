import Mathlib

/-- A Walrasian equilibrium in a one-consumer, one-producer economy.
    Given demand functions x₁, x₂ (for leisure and consumption), supply function q,
    and labor demand z, an equilibrium is a price-wage pair (p, w) at which
    the consumption market clears (x₂ = q) and the labor market clears (z = L - x₁). -/
structure WalrasianEquilibrium
    (x₁ : ℝ → ℝ → ℝ)
    (x₂ : ℝ → ℝ → ℝ)
    (q : ℝ → ℝ → ℝ)
    (z : ℝ → ℝ → ℝ)
    (L : ℝ) where
  /-- Equilibrium price -/
  p : ℝ
  /-- Equilibrium wage -/
  w : ℝ
  /-- Consumption market clears: consumer demand for the good equals firm output -/
  consumption_clears : x₂ p w = q p w
  /-- Labor market clears: firm labor demand equals total time endowment minus leisure -/
  labor_clears : z p w = L - x₁ p w