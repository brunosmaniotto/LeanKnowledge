import Mathlib
open BigOperators

/-- A linear programming problem in standard (primal) form:
    maximize f · x subject to x ∈ ℝ₊ᴺ and A x ≤ c. -/
structure MWG.LinearProgram (N K : ℕ) where
  /-- Constraint matrix (K × N) -/
  A : Matrix (Fin K) (Fin N) ℝ
  /-- Objective vector -/
  f : Fin N → ℝ
  /-- Constraint bound vector -/
  c : Fin K → ℝ

namespace MWG.LinearProgram

/-- The feasible set: nonnegative vectors satisfying Ax ≤ c. -/
noncomputable def feasibleSet {N K : ℕ} (lp : LinearProgram N K) : Set (Fin N → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∀ k, ∑ j, lp.A k j * x j ≤ lp.c k}

/-- The objective value f · x. -/
noncomputable def objective {N K : ℕ} (lp : LinearProgram N K) (x : Fin N → ℝ) : ℝ :=
  ∑ i, lp.f i * x i

end MWG.LinearProgram