import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

/-- The budget set: nonneg bundles x with p · x ≤ y -/
def BudgetSet {n : ℕ} (p : Fin n → ℝ) (y : ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ y}

/-- The Marshallian (ordinary) demand function x(p, y). Given utility u, prices p,
    and income y, returns the unique utility-maximizing bundle in the budget set.
    Uses classical choice; well-defined when the maximizer is unique. -/
noncomputable def marshallianDemand {n : ℕ} (u : (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ) (y : ℝ) : Fin n → ℝ :=
  Classical.epsilon fun x =>
    x ∈ BudgetSet p y ∧ ∀ x' ∈ BudgetSet p y, u x' ≤ u x