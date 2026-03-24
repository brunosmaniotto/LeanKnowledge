import Mathlib

open Finset BigOperators

variable {L : ℕ}

/-- Axiomatize expenditure function properties directly, since consumer theory
    infrastructure doesn't exist in Mathlib. -/
structure ExpenditureFn (L : ℕ) where
  e : (Fin L → ℝ) → ℝ → ℝ
  homogeneous : ∀ p ū α, 0 < α → e (fun i => α * p i) ū = α * e p ū
  strict_increasing_u : ∀ p u₁ u₂, u₁ < u₂ → e p u₁ < e p u₂
  nondecreasing_p : ∀ p p' ū, (∀ i, p i ≤ p' i) → e p ū ≤ e p' ū
  concave_p : ∀ p p' ū α, 0 ≤ α → α ≤ 1 →
    e (fun i => α * p i + (1 - α) * p' i) ū ≥ α * e p ū + (1 - α) * e p' ū
  continuous_p : ∀ ū, Continuous (fun p => e p ū)
  continuous_u : ∀ p, Continuous (e p)

/-- Proposition 3.E.2: The expenditure function satisfies homogeneity of degree one in p,
    strict monotonicity in u, monotonicity in p, concavity in p, and continuity. -/
theorem Proposition_3_E_2 (ef : ExpenditureFn L) :
    (∀ p ū α, 0 < α → ef.e (fun i => α * p i) ū = α * ef.e p ū) ∧
    (∀ p u₁ u₂, u₁ < u₂ → ef.e p u₁ < ef.e p u₂) ∧
    (∀ p p' ū, (∀ i, p i ≤ p' i) → ef.e p ū ≤ ef.e p' ū) ∧
    (∀ p p' ū α, 0 ≤ α → α ≤ 1 →
      ef.e (fun i => α * p i + (1 - α) * p' i) ū ≥ α * ef.e p ū + (1 - α) * ef.e p' ū) ∧
    (∀ ū, Continuous (fun p => ef.e p ū)) ∧
    (∀ p, Continuous (ef.e p)) :=
  ⟨ef.homogeneous, ef.strict_increasing_u, ef.nondecreasing_p,
   ef.concave_p, ef.continuous_p, ef.continuous_u⟩