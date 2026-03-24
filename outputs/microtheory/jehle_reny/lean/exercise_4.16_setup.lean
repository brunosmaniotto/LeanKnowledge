import Mathlib

open Finset
open Topology
open BigOperators

/-- The composite commodity utility function ū(q, m):
    given utility u(q, x) over good q and goods x with price vector p,
    define m = p·x and ū(q, m) = max_x u(q, x) s.t. p·x ≤ m. -/
noncomputable def compositeUtility {n : ℕ} (u : ℝ → (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ) (q m : ℝ) : ℝ :=
  sSup {v : ℝ | ∃ x : Fin n → ℝ, ∑ i : Fin n, p i * x i ≤ m ∧ v = u q x}