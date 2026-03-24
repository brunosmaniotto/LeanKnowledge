import Mathlib

/-- A production function F : ℝ → ℝ → ℝ with partial derivatives. -/
structure RamseySolowProduction where
  F : ℝ → ℝ → ℝ
  /-- Partial derivative of F with respect to the first argument (capital). -/
  D₁F : ℝ → ℝ → ℝ
  /-- Partial derivative of F with respect to the second argument (labor). -/
  D₂F : ℝ → ℝ → ℝ

variable (P : RamseySolowProduction)

/-- Surplus (consumption) level at stationary capital k with l = 1: c(k) = F(k,1) - k. -/
noncomputable def RamseySolowProduction.surplus (k : ℝ) : ℝ :=
  P.F k 1 - k

/-- Net marginal productivity of capital (rate of interest): r(k) = D₁F(k,1) - 1. -/
noncomputable def RamseySolowProduction.rateOfInterest (k : ℝ) : ℝ :=
  P.D₁F k 1 - 1

/-- Supporting price at time t: q_t = q₀ / (1 + r(k))^t. -/
noncomputable def RamseySolowProduction.supportingPrice (k : ℝ) (q₀ : ℝ) (t : ℕ) : ℝ :=
  q₀ / (1 + P.rateOfInterest k) ^ t

/-- Supporting wage at time t: w_t = w₀ / (1 + r(k))^t.
    Here w₀ = q₀ · D₂F(k,1). -/
noncomputable def RamseySolowProduction.supportingWage (k : ℝ) (q₀ : ℝ) (t : ℕ) : ℝ :=
  (q₀ * P.D₂F k 1) / (1 + P.rateOfInterest k) ^ t

/-- Real wage at stationary capital k: w(k) = w₀/q₀ = D₂F(k,1). -/
noncomputable def RamseySolowProduction.realWage (k : ℝ) : ℝ :=
  P.D₂F k 1

/-- The supporting price-wage pair at time t. -/
noncomputable def RamseySolowProduction.supportingPriceWage (k : ℝ) (q₀ : ℝ) (t : ℕ) : ℝ × ℝ :=
  (P.supportingPrice k q₀ t, P.supportingWage k q₀ t)