import Mathlib

/-- A 2×2 production model with factor intensity condition -/
structure TwoByTwoModel where
  /-- Unit input coefficients aᵢⱼ(w) as functions of factor prices -/
  a : Fin 2 → Fin 2 → ℝ → ℝ
  /-- Factor endowments -/
  z : Fin 2 → ℝ
  /-- Goods prices -/
  p : Fin 2 → ℝ
  /-- Unit cost functions -/
  c : Fin 2 → ℝ → ℝ
  /-- Equilibrium factor price (unique solution to c₁(w) = p₁, c₂(w) = p₂) -/
  w_eq : ℝ
  /-- Positive endowments -/
  z_pos : ∀ i, 0 < z i
  /-- Positive input coefficients at equilibrium -/
  a_pos : ∀ i j, 0 < a i j w_eq
  /-- Factor intensity condition: good 1 is more intensive in factor 1 -/
  factor_intensity : a 0 0 w_eq / a 1 0 w_eq > a 0 1 w_eq / a 1 1 w_eq
  /-- Equilibrium prices equal unit costs -/
  eq_prices : ∀ i, c i w_eq = p (i : Fin 2)

/-- Production levels -/
def TwoByTwoModel.positiveProduction (m : TwoByTwoModel) (y : Fin 2 → ℝ) : Prop :=
  (∀ i, 0 < y i) ∧
  (∀ j, m.a j 0 m.w_eq * y 0 + m.a j 1 m.w_eq * y 1 = m.z j)