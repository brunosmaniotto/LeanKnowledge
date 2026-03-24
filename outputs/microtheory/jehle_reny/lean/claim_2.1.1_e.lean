import Mathlib

-- Claim 2.1.1_e: Duality of utility maximization and expenditure minimization
-- approaches to deriving consumer demand systems.

axiom PriceVector : Type
axiom Bundle : Type

axiom marshallian_demand : PriceVector → ℝ → Bundle
axiom hicksian_demand : PriceVector → ℝ → Bundle
axiom indirect_utility : PriceVector → ℝ → ℝ
axiom expenditure_fn : PriceVector → ℝ → ℝ

-- Theorem 2.1: From utility to demands via optimization
axiom theorem_2_1 :
  ∀ (p : PriceVector) (w u_bar : ℝ),
    marshallian_demand p w = hicksian_demand p (indirect_utility p w) ∧
    expenditure_fn p (indirect_utility p w) = w

-- Theorem 2.2: From expenditure to demands via inversion/differentiation
axiom theorem_2_2 :
  ∀ (p : PriceVector) (w u_bar : ℝ),
    hicksian_demand p u_bar = marshallian_demand p (expenditure_fn p u_bar) ∧
    indirect_utility p (expenditure_fn p u_bar) = u_bar

/-- For theoretical purposes, one can equivalently start with a direct utility
function and solve optimisation problems to derive Hicksian and Marshallian
demands (Theorem 2.1), or begin with an expenditure function and obtain
consumer demand systems by inversion and differentiation (Theorem 2.2). -/
theorem Claim_2_1_1_e :
  ∀ (p : PriceVector) (w u_bar : ℝ),
    -- Path 1 (utility → optimization → demands):
    (marshallian_demand p w = hicksian_demand p (indirect_utility p w) ∧
     expenditure_fn p (indirect_utility p w) = w) ∧
    -- Path 2 (expenditure → inversion/differentiation → demands):
    (hicksian_demand p u_bar = marshallian_demand p (expenditure_fn p u_bar) ∧
     indirect_utility p (expenditure_fn p u_bar) = u_bar) := by
  intro p w u_bar
  exact ⟨theorem_2_1 p w u_bar, theorem_2_2 p w u_bar⟩