import Mathlib
open Topology Set

/-- Assumption 1.2: The consumer's utility function u(·) is continuous,
    strictly increasing, and strictly quasiconcave on ℝⁿ₊. -/
def ConsumerUtilityAssumption (n : ℕ) (u : (Fin n → ℝ) → ℝ) : Prop :=
  Continuous u ∧
  (∀ x y : Fin n → ℝ, (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) →
    (∀ i, x i ≤ y i) → (∃ i, x i < y i) → u x < u y) ∧
  (∀ x y : Fin n → ℝ, (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) →
    x ≠ y → u x = u y → ∀ t : ℝ, 0 < t → t < 1 →
    u (fun i => t * x i + (1 - t) * y i) > u x)