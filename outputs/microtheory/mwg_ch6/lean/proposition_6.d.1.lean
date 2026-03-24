import Mathlib

/-
Proposition 6.D.1 (MWG): First-order stochastic dominance is equivalent to
pointwise CDF ordering F(x) ≤ G(x) for all x.

We model distributions over a finite linearly ordered type with real-valued
CDFs, and define FOSD via the expected-utility characterization: for every
nondecreasing utility function, the expectation under F is at least that under G.
-/

open Finset BigOperators
open BigOperators

/-- A discrete distribution over a finite ordered type, given by a PMF. -/
structure DiscreteDist (α : Type*) [Fintype α] where
  pmf : α → ℝ
  pmf_nonneg : ∀ a, 0 ≤ pmf a
  pmf_sum_one : ∑ a : α, pmf a = 1

noncomputable def cdf {α : Type*} [Fintype α] [LinearOrder α] [DecidableRel (α := α) (· ≤ ·)]
    (D : DiscreteDist α) (x : α) : ℝ :=
  ∑ a ∈ Finset.univ.filter (· ≤ x), D.pmf a

noncomputable def expectedValue {α : Type*} [Fintype α]
    (D : DiscreteDist α) (u : α → ℝ) : ℝ :=
  ∑ a : α, D.pmf a * u a

/-- First-order stochastic dominance: every nondecreasing utility has weakly higher
    expectation under F than under G. -/
def fosd {α : Type*} [Fintype α] [Preorder α]
    (F G : DiscreteDist α) : Prop :=
  ∀ u : α → ℝ, Monotone u → expectedValue F u ≥ expectedValue G u