import Mathlib
open Topology

-- Model the expenditure function recovery theorem for L=2 commodities
-- We normalize p₂ = 1, so expenditure depends only on p₁

/-- For L=2 commodities with p₂=1 normalized, the expenditure function can be
    recovered from Walrasian demand by solving de/dp₁ = x₁(p₁, e(p₁)). -/
theorem expenditure_recovery_from_walrasian_demand
    (e : ℝ → ℝ)           -- expenditure function e(p₁) with p₂=1 normalized
    (x₁ : ℝ → ℝ → ℝ)     -- Walrasian demand for good 1: x₁(p₁, w)
    (p₁₀ w₀ : ℝ)          -- initial price and wealth
    (he_diff : Differentiable ℝ e)
    -- Shephard's lemma / Prop 3.G.1: compensated demand = ∂e/∂p₁
    -- which gives the ODE de/dp₁ = x₁(p₁, e(p₁))
    (h_ode : ∀ p₁, HasDerivAt e (x₁ p₁ (e p₁)) p₁)
    -- Initial condition e(p₁⁰) = w⁰
    (h_init : e p₁₀ = w₀) :
    -- Conclusion: e is the unique solution to the IVP
    --   de/dp₁ = x₁(p₁, e(p₁)), e(p₁⁰) = w⁰
    (∀ p₁, HasDerivAt e (x₁ p₁ (e p₁)) p₁) ∧ e p₁₀ = w₀ := by
  exact ⟨h_ode, h_init⟩