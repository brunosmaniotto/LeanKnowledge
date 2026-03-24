import Mathlib

open Topology Set

/-- The non-negative orthant ℝⁿ₊ -/
def nnOrthant (n : ℕ) : Set (Fin n → ℝ) :=
  {x | ∀ i, 0 ≤ x i}

/-- Assumption 1.2: The consumer's utility function u on ℝⁿ₊ is continuous,
    strictly increasing, and strictly quasiconcave. These properties follow
    from the preference relation ≿ being complete, transitive, continuous,
    strictly monotonic, and strictly convex (via Theorems 1.1 and 1.3). -/
structure Assumption_1_2 {n : ℕ} (u : (Fin n → ℝ) → ℝ) : Prop where
  continuous_u : ContinuousOn u (nnOrthant n)
  strictly_increasing : ∀ x ∈ nnOrthant n, ∀ y ∈ nnOrthant n,
    (∀ i, y i ≤ x i) → x ≠ y → u y < u x
  strictly_quasiconcave : ∀ x ∈ nnOrthant n, ∀ y ∈ nnOrthant n,
    x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      u (fun i => t * x i + (1 - t) * y i) > min (u x) (u y)