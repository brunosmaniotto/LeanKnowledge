import Mathlib
open scoped symmDiff
open Topology
open BigOperators

-- Walrasian equilibrium characterization via excess expenditure equations
-- An allocation s* in the simplex corresponds to a Walrasian equilibrium
-- iff the excess expenditure g_i(s*) = p(s*) · (ω_i - x_i(s*)) = 0 for all consumers i.

variable {I L : ℕ} -- I consumers, L commodities

-- Economic primitives
variable (Δ : Set (Fin I → ℝ))  -- simplex of welfare weights
variable (x : (Fin I → ℝ) → Fin I → Fin L → ℝ)  -- Pareto optimal allocation map
variable (p : (Fin I → ℝ) → Fin L → ℝ)  -- supporting price vector
variable (ω : Fin I → Fin L → ℝ)  -- endowments

-- Excess expenditure function
noncomputable def excess_expenditure
    (p : (Fin I → ℝ) → Fin L → ℝ)
    (ω : Fin I → Fin L → ℝ)
    (x : (Fin I → ℝ) → Fin I → Fin L → ℝ)
    (s : Fin I → ℝ) (i : Fin I) : ℝ :=
  ∑ l : Fin L, p s l * (ω i l - x s i l)

-- Walrasian equilibrium predicate
def IsWalrasianEquilibrium
    (p : (Fin I → ℝ) → Fin L → ℝ)
    (ω : Fin I → Fin L → ℝ)
    (x : (Fin I → ℝ) → Fin I → Fin L → ℝ)
    (s : Fin I → ℝ) : Prop :=
  ∀ i : Fin I, excess_expenditure p ω x s i = 0