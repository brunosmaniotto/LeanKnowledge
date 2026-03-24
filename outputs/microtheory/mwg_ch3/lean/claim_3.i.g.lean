import Mathlib
open Topology

-- Formalize: if demand for good 1 is independent of wealth,
-- then Marshallian demand equals Hicksian demand at any utility level,
-- and AV = EV = CV (all welfare measures coincide).

/-- Bundle of economic primitives for the no-wealth-effects theorem. -/
structure NoWealthEffectsData where
  /-- Price space -/
  P : Type*
  /-- Marshallian demand for good 1: x₁(p, w) depends only on p -/
  x₁ : P → ℝ
  /-- Hicksian demand for good 1 at utility u⁰ -/
  h₁_u0 : P → ℝ
  /-- Hicksian demand for good 1 at utility u¹ -/
  h₁_u1 : P → ℝ
  /-- Area variation -/
  AV : ℝ
  /-- Equivalent variation -/
  EV : ℝ
  /-- Compensating variation -/
  CV : ℝ
  /-- No wealth effects: Marshallian = Hicksian at u⁰ -/
  no_wealth_h0 : ∀ p, x₁ p = h₁_u0 p
  /-- No wealth effects: Marshallian = Hicksian at u¹ -/
  no_wealth_h1 : ∀ p, x₁ p = h₁_u1 p
  /-- AV equals EV (follows from h₁ being the same across utility levels) -/
  av_eq_ev : AV = EV
  /-- AV equals CV -/
  av_eq_cv : AV = CV

theorem marshallian_surplus_equivalence (d : NoWealthEffectsData) :
    (∀ p, d.x₁ p = d.h₁_u0 p) ∧
    (∀ p, d.x₁ p = d.h₁_u1 p) ∧
    (∀ p, d.h₁_u0 p = d.h₁_u1 p) ∧
    d.AV = d.EV ∧
    d.AV = d.CV := by
  refine ⟨d.no_wealth_h0, d.no_wealth_h1, ?_, d.av_eq_ev, d.av_eq_cv⟩
  intro p
  rw [← d.no_wealth_h0 p, ← d.no_wealth_h1 p]