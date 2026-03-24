import Mathlib
open Topology

/-- Monotonicity of preferences implies the utility function is increasing:
    if x >> y (strict dominance), then u(x) > u(y). -/
theorem utility_monotone
    {n : ℕ} (u : (Fin n → ℝ) → ℝ)
    (mono : ∀ x y : Fin n → ℝ, (∀ i, y i < x i) → u y < u x)
    (x y : Fin n → ℝ)
    (hdom : ∀ i, y i < x i) :
    u y < u x := by
  exact mono x y hdom