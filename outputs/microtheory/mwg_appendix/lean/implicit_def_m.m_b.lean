import Mathlib

open Matrix Finset BigOperators
open Topology
open BigOperators

/-- The dual linear programming problem: Min c·μ s.t. μ ≥ 0, Aᵀμ ≥ f.
    Given a primal problem Max f·x s.t. x ≥ 0, Ax ≤ c with
    N decision variables and K constraints. -/
structure DualLP (N K : ℕ) where
  /-- Constraint matrix (K × N) -/
  A : Matrix (Fin K) (Fin N) ℝ
  /-- Right-hand side of primal constraints -/
  c : Fin K → ℝ
  /-- Primal objective coefficients -/
  f : Fin N → ℝ

namespace DualLP

/-- A feasible dual vector: μ ≥ 0 and Aᵀμ ≥ f -/
structure FeasibleSol (P : DualLP N K) where
  mu : Fin K → ℝ
  nonneg : ∀ k, 0 ≤ mu k
  dual_constraint : ∀ n, P.f n ≤ ∑ k, P.A k n * mu k

/-- The dual objective value: c · μ -/
noncomputable def objective (P : DualLP N K) (sol : P.FeasibleSol) : ℝ :=
  ∑ k, P.c k * sol.mu k

/-- The dual problem asks to minimize c·μ over all feasible dual vectors -/
def IsOptimal (P : DualLP N K) (sol : P.FeasibleSol) : Prop :=
  ∀ sol' : P.FeasibleSol, P.objective sol ≤ P.objective sol'

end DualLP