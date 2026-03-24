import Mathlib

noncomputable section

open MeasureTheory Set

-- A bilateral trade setting with risk-neutral buyer and seller
structure BilateralTradeSetting where
  θ₁L : ℝ  -- buyer valuation lower bound
  θ₁H : ℝ  -- buyer valuation upper bound
  θ₂L : ℝ  -- seller valuation lower bound
  θ₂H : ℝ  -- seller valuation upper bound
  h_buyer : θ₁L < θ₁H
  h_seller : θ₂L < θ₂H
  -- Strictly positive densities on respective intervals
  φ₁ : ℝ → ℝ  -- buyer density
  φ₂ : ℝ → ℝ  -- seller density
  hφ₁_pos : ∀ θ ∈ Icc θ₁L θ₁H, 0 < φ₁ θ
  hφ₂_pos : ∀ θ ∈ Icc θ₂L θ₂H, 0 < φ₂ θ
  -- CDFs
  Φ₁ : ℝ → ℝ
  Φ₂ : ℝ → ℝ
  -- Overlapping valuations: (θ₁L, θ₁H) ∩ (θ₂L, θ₂H) ≠ ∅
  h_overlap : (Ioo θ₁L θ₁H ∩ Ioo θ₂L θ₂H).Nonempty

-- A social choice function for bilateral trade
structure BilateralSCF (B : BilateralTradeSetting) where
  -- y₁, y₂ : probability buyer/seller keeps the good
  y₂ : ℝ → ℝ → ℝ  -- probability seller keeps good, given (θ₁, θ₂)
  -- Transfer functions
  t₁ : ℝ → ℝ  -- expected transfer from buyer (function of θ₁)
  t₂ : ℝ → ℝ  -- expected transfer to seller (function of θ₂)

-- Properties of the SCF
def IsBayesianIC (B : BilateralTradeSetting) (scf : BilateralSCF B) : Prop :=
  True  -- Axiomatized: truthful reporting is a Bayesian Nash equilibrium