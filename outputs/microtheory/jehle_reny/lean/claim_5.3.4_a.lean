import Mathlib
open Finset BigOperators
open Topology
open BigOperators

variable {I J L : ℕ}

/-- Walrasian Equilibrium Allocation: combines utility max, profit max, market clearing -/
structure IsWEA
    (Xi : Fin I → Set (Fin L → ℝ))
    (pref : Fin I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (Yj : Fin J → Set (Fin L → ℝ))
    (e : Fin I → Fin L → ℝ)
    (θ : Fin I → Fin J → ℝ)
    (p : Fin L → ℝ)
    (x : Fin I → Fin L → ℝ)
    (y : Fin J → Fin L → ℝ) : Prop where
  utilMax : ∀ i, x i ∈ Xi i ∧
    ∀ x' ∈ Xi i, (∑ l, p l * x' l ≤ ∑ l, p l * (e i) l + ∑ j, θ i j * ∑ l, p l * (y j) l) →
      pref i (x i) x' ∨ x i = x'
  profitMax : ∀ j, y j ∈ Yj j ∧
    ∀ y' ∈ Yj j, ∑ l, p l * (y j) l ≥ ∑ l, p l * y' l
  marketClearing : ∀ l, ∑ i, (x i) l = ∑ i, (e i) l + ∑ j, (y j) l

theorem claim_5_3_4_a
    (Xi : Fin I → Set (Fin L → ℝ))
    (pref : Fin I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (Yj : Fin J → Set (Fin L → ℝ))
    (e : Fin I → Fin L → ℝ)
    (θ : Fin I → Fin J → ℝ)
    (p : Fin L → ℝ)
    (x : Fin I → Fin L → ℝ)
    (y : Fin J → Fin L → ℝ) :
    IsWEA Xi pref Yj e θ p x y ↔
      (∀ i, x i ∈ Xi i ∧
        ∀ x' ∈ Xi i, (∑ l, p l * x' l ≤ ∑ l, p l * (e i) l + ∑ j, θ i j * ∑ l, p l * (y j) l) →
          pref i (x i) x' ∨ x i = x') ∧
      (∀ j, y j ∈ Yj j ∧
        ∀ y' ∈ Yj j, ∑ l, p l * (y j) l ≥ ∑ l, p l * y' l) ∧
      (∀ l, ∑ i, (x i) l = ∑ i, (e i) l + ∑ j, (y j) l) := by
  constructor
  · intro h
    exact ⟨h.utilMax, h.profitMax, h.marketClearing⟩
  · intro ⟨h1, h2, h3⟩
    exact ⟨h1, h2, h3⟩