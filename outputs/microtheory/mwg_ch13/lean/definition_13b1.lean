import Mathlib

open MeasureTheory

/-- A competitive equilibrium in the adverse selection labor market model.
    Workers have types θ distributed according to some measure, with reservation
    wage r(θ). A competitive equilibrium is a wage w* and acceptance set Θ*
    satisfying two conditions. -/
structure CompetitiveEquilibrium
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω)          -- distribution of worker types
    (θ : Ω → ℝ)              -- productivity (random variable on the type space)
    (r : ℝ → ℝ)              -- reservation wage as a function of productivity
    where
  /-- Equilibrium wage rate -/
  wage : ℝ
  /-- Set of worker types who accept employment -/
  acceptSet : Set ℝ
  /-- (i) Workers accept iff their reservation wage is at most w* -/
  accept_iff : acceptSet = {t : ℝ | r t ≤ wage}
  /-- (ii) The wage equals the expected productivity conditional on acceptance -/
  wage_eq_cond_exp :
    wage = (∫ ω in {ω | θ ω ∈ acceptSet}, θ ω ∂μ) / (μ {ω | θ ω ∈ acceptSet}).toReal