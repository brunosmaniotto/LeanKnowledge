import Mathlib

open scoped BigOperators
open BigOperators
open Finset

/-- A feasible path in the dynamic programming problem: an infinite sequence
    starting at z with all values in A. -/
def FeasiblePath {N : ℕ} (A : Set (Fin N → ℝ)) (z : Fin N → ℝ) :=
  { x : ℕ → (Fin N → ℝ) // x 0 = z ∧ ∀ t, x t ∈ A }

/-- The discounted payoff of a feasible path over a finite horizon T. -/
noncomputable def discountedPayoff {N : ℕ} (u : (Fin N → ℝ) → (Fin N → ℝ) → ℝ)
    (δ : ℝ) (x : ℕ → (Fin N → ℝ)) (T : ℕ) : ℝ :=
  ∑ t ∈ Finset.range T, δ ^ t * u (x t) (x (t + 1))

/-- The value function for the infinite-horizon dynamic programming problem.
    Given a nonempty compact set A ⊂ ℝᴺ, a continuous utility function u : A × A → ℝ,
    a discount factor δ ∈ (0,1), and initial state z ∈ A, v(z) is the supremum
    of the infinite discounted sum Σₜ₌₀^∞ δᵗ u(xₜ, xₜ₊₁) over all feasible paths
    starting at z. -/
noncomputable def MWG.valueFunction {N : ℕ} (A : Set (Fin N → ℝ))
    (u : (Fin N → ℝ) → (Fin N → ℝ) → ℝ) (δ : ℝ) (z : Fin N → ℝ) : ℝ :=
  ⨆ (path : FeasiblePath A z),
    ⨆ (T : ℕ), discountedPayoff u δ path.val T