import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A Lindahl equilibrium for a public goods economy with personalized commodities. -/
structure LindahlEquilibrium
    (I : Type*) [Fintype I] [DecidableEq I]
    (X : I → Set (ℝ × ℝ))
    (pref : I → (ℝ × ℝ) → (ℝ × ℝ) → Prop)
    (f : ℝ → ℝ)
    (ω₁ : ℝ) where
  /-- Private good allocation for each consumer -/
  x₁ : I → ℝ
  /-- Public good consumption for each consumer (equal in equilibrium) -/
  x₂ : I → ℝ
  /-- Public good quantity -/
  q : ℝ
  /-- Input to public good production -/
  z : ℝ
  /-- Personalized price for the public good for each consumer -/
  p₂ : I → ℝ
  /-- Wealth level for each consumer -/
  w : I → ℝ
  /-- Walras' law: total wealth equals value of consumption plus firm profit -/
  walras_law : ∑ i : I, w i =
    ∑ i : I, x₁ i + (∑ i : I, p₂ i) * q - z
  /-- Production feasibility: output does not exceed production function -/
  production_feasible : q ≤ f z
  /-- Profit maximization: firm maximizes at equilibrium -/
  profit_max : ∀ q' z' : ℝ, z' ≥ 0 → q' ≤ f z' →
    (∑ i : I, p₂ i) * q' - z' ≤ (∑ i : I, p₂ i) * q - z
  /-- Utility maximization: each consumer's bundle is preferred to all affordable bundles -/
  utility_max : ∀ i : I, ∀ x₁' x₂' : ℝ,
    (x₁', x₂') ∈ X i → x₁' + p₂ i * x₂' ≤ w i →
    ¬ pref i (x₁', x₂') (x₁ i, x₂ i)
  /-- Market clearing for private good -/
  private_good_clear : ∑ i : I, x₁ i + z = ω₁
  /-- Market clearing for public good: all consumers receive the same quantity -/
  public_good_clear : ∀ i : I, x₂ i = q