import Mathlib
open Topology

/-- Axiom 5' (Convexity): If x₁ ≿ x₀, then every convex combination
    t·x₁ + (1−t)·x₀ ≿ x₀ for all t ∈ [0, 1]. -/
def IsConvexPreference {n : ℕ} (pref : (Fin n → ℝ) → (Fin n → ℝ) → Prop) : Prop :=
  ∀ (x₀ x₁ : Fin n → ℝ), pref x₁ x₀ →
    ∀ (t : ℝ), 0 ≤ t → t ≤ 1 →
      pref (t • x₁ + (1 - t) • x₀) x₀