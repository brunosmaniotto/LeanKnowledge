import Mathlib
open Topology
open BigOperators

/-- A production plan's market value given asset prices -/
noncomputable def marketValue {S : Type*} [Fintype S] (returns : S → ℝ) (q : S → ℝ) : ℝ :=
  ∑ s : S, returns s * q s

/-- Budget set for consumer i under production plan a:
    consumer can afford consumption bundles funded by initial wealth plus
    ownership share times market value of the production plan -/
def budgetSet {S : Type*} [Fintype S] (w_i : ℝ) (θ_i : ℝ) (v : ℝ) : Set ℝ :=
  {x | x ≤ w_i + θ_i * v}