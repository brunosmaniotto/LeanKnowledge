import Mathlib
open Topology

noncomputable def deadweight_loss
    (e : (Fin n → ℝ) → ℝ → ℝ)       -- expenditure function e(p, u)
    (x₁ : (Fin n → ℝ) → ℝ → ℝ)      -- Marshallian demand for good 1
    (p₀ : Fin n → ℝ)                  -- initial price vector
    (p₁ : Fin n → ℝ)                  -- post-tax price vector (p₁⁰ + t, p₋₁)
    (w : ℝ)                            -- wealth
    (u₁ : ℝ)                           -- post-tax utility level
    (t : ℝ)                            -- per-unit tax on good 1
    : ℝ :=
  let T := t * x₁ p₁ w
  (-T) - (w - T - e p₀ u₁)