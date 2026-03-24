import Mathlib
open Topology

noncomputable section

-- From Proven Dependencies: Def_4.2_NashEqMarket
-- Defines the partial derivative of a multivariable function `f` with respect to its `k`-th argument at point `q k`.
def partialDeriv {J : ℕ} (f : (Fin J → ℝ) → ℝ) (k : Fin J) (q : Fin J → ℝ) : ℝ :=
  deriv (fun t => f (Function.update q k t)) (q k)

variable {J : ℕ} [Fact (0 < J)] -- Ensures J is at least 1, meaning Finset.univ is not empty.
variable (π : Fin J → (Fin J → ℝ) → ℝ) -- π_j is the profit function for firm j.

-- The component of the First-Order Condition for firm k under Nash equilibrium.
-- This term represents firm k's own profit derivative with respect to its output.