import Mathlib

/-- A set A of pairs (k, k') is the admissible region. A path is a sequence ℕ → ℝ.
    A path is strictly interior to A if there exists ε > 0 such that for every t,
    the ε-neighborhood of (k_t, k_{t+1}) is entirely contained in A. -/
def IsStrictlyInteriorPath (A : Set (ℝ × ℝ)) (k : ℕ → ℝ) : Prop :=
  ∃ ε > 0, ∀ t : ℕ, ∀ p : ℝ × ℝ, dist p (k t, k (t + 1)) < ε → p ∈ A