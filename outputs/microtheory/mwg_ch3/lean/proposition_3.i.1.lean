import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ} {ι : Type*} [Fintype ι]

/-- Budget set: bundles x such that p · x ≤ w -/
def BudgetSet (p : ι → ℝ) (w : ℝ) : Set (ι → ℝ) :=
  {x | ∑ i : ι, p i * x i ≤ w}

/-- A preference relation on bundles -/
structure Pref (ι : Type*) [Fintype ι] where
  weakPref : (ι → ℝ) → (ι → ℝ) → Prop
  strictPref : (ι → ℝ) → (ι → ℝ) → Prop