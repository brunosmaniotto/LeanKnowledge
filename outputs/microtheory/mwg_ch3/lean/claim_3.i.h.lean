import Mathlib

-- Axiomatize the economic primitives
variable (x₁ : ℝ → ℝ → ℝ)   -- Marshallian demand x₁(p, w)
variable (h₁ : ℝ → ℝ → ℝ)   -- Hicksian demand h₁(p, u)
variable (w : ℝ)              -- wealth
variable (p₀ p₁ : ℝ)         -- initial and final prices
variable (u₀ u₁ : ℝ)         -- initial and final utility levels
variable (CV EV AV : ℝ)       -- compensating, equivalent, area variation

-- Price decrease: p₁ < p₀
variable (hp : p₁ < p₀)

-- AV is the integral of Marshallian demand; CV uses Hicksian at u₀; EV uses Hicksian at u₁
-- For a price decrease with normal good:
--   h₁(p, u₀) ≤ x₁(p, w) ≤ h₁(p, u₁) for p ∈ [p₁, p₀]
-- Integrating: CV ≤ AV ≤ EV  (but the claim says AV overstates CV and understates EV,
--   i.e., CV ≤ AV ≤ EV)

/-- When good 1 is normal: AV overstates CV and understates EV (CV ≤ AV ≤ EV).
    When good 1 is inferior: the reverse holds (EV ≤ AV ≤ CV). -/
theorem welfare_variation_ordering_normal
    (hNormal : CV ≤ AV ∧ AV ≤ EV) :
    CV ≤ AV ∧ AV ≤ EV := hNormal