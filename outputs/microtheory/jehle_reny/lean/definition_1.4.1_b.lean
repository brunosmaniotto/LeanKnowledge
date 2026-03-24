import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The indirect utility function v(p, y) gives the maximum utility achievable
    at prices p and income y over the nonnegative orthant R^n_+. -/
noncomputable def indirectUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ) (y : ℝ) : ℝ :=
  sSup {v : ℝ | ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ y ∧ u x = v}