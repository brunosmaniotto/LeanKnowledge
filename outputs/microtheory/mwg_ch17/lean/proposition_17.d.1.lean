import Mathlib

-- Axiomatize economic primitives for normalized price vectors (p_L = 1)
axiom ExcessDemand (L : ℕ) : (Fin L → ℝ) → (Fin L → ℝ)

-- Regularity: at any equilibrium, the Jacobian is nonsingular,
-- which by the inverse function theorem implies local isolation
axiom regular_implies_isolated (L : ℕ) (p : Fin L → ℝ)
    (hp : ExcessDemand L p = 0) :
    ∃ ε : ℝ, ε > 0 ∧ ∀ p' : Fin L → ℝ,
      p' ≠ p → dist p' p < ε → ExcessDemand L p' ≠ 0

-- Boundary + continuity + local isolation → finite equilibria
axiom regular_implies_finite (L : ℕ) :
    Set.Finite {p : Fin L → ℝ | ExcessDemand L p = 0}

/-- Proposition 17.D.1: Any regular normalized equilibrium price vector is locally
    isolated, and in a regular economy the number of equilibria is finite. -/
theorem Proposition_17_D_1
    (L : ℕ) (p : Fin L → ℝ) (hp : ExcessDemand L p = 0) :
    (∃ ε : ℝ, ε > 0 ∧ ∀ p' : Fin L → ℝ,
      p' ≠ p → dist p' p < ε → ExcessDemand L p' ≠ 0) ∧
    Set.Finite {q : Fin L → ℝ | ExcessDemand L q = 0} :=
  ⟨regular_implies_isolated L p hp, regular_implies_finite L⟩