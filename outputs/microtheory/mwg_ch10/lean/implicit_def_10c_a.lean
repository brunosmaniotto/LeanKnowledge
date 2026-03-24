import Mathlib
open Topology

/-- A consumer in the partial equilibrium two-good quasilinear model.
    Consumer i has utility u_i(m_i, x_i) = m_i + φ_i(x_i) where m_i is the
    numeraire consumption and x_i is consumption of good ℓ. -/
structure QuasilinearConsumer where
  /-- The valuation function φ_i for good ℓ -/
  φ : ℝ → ℝ
  /-- φ is twice differentiable on (0, ∞) -/
  φ_twice_diff : ∀ x : ℝ, 0 < x → DifferentiableAt ℝ φ x
  φ_deriv_diff : ∀ x : ℝ, 0 < x → DifferentiableAt ℝ (deriv φ) x
  /-- φ'(x) > 0 for all x > 0 (strictly increasing) -/
  φ_deriv_pos : ∀ x : ℝ, 0 < x → 0 < deriv φ x
  /-- φ''(x) < 0 for all x > 0 (strictly concave) -/
  φ_deriv2_neg : ∀ x : ℝ, 0 < x → deriv (deriv φ) x < 0
  /-- φ(0) = 0 -/
  φ_zero : φ 0 = 0
  /-- φ is bounded above -/
  φ_bdd_above : BddAbove (Set.range φ)

/-- The partial equilibrium two-good quasilinear economy.
    There are I consumers, each with quasilinear utility m_i + φ_i(x_i),
    consumption set ℝ × ℝ₊, and the numeraire price is normalized to 1. -/
structure QuasilinearEconomy (I : Type*) [Fintype I] where
  /-- Each consumer's quasilinear preference -/
  consumer : I → QuasilinearConsumer
  /-- Price of good ℓ (numeraire price normalized to 1) -/
  p : ℝ

/-- The utility function for consumer i: u_i(m_i, x_i) = m_i + φ_i(x_i) -/
noncomputable def QuasilinearEconomy.utility {I : Type*} [Fintype I]
    (E : QuasilinearEconomy I) (i : I) (m x : ℝ) : ℝ :=
  m + (E.consumer i).φ x