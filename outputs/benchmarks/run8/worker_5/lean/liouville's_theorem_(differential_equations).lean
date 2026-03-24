import Mathlib

open Matrix
open Real

theorem liouville_formula_ode {n : Type u} [Fintype n] [DecidableEq n]
    {A : ℝ → Matrix n n ℝ} {Φ : ℝ → Matrix n n ℝ}
    (hA : Continuous A) (hΦ : ∀ t, HasDerivAt Φ (A t * Φ t) t) (t₀ t : ℝ) :
    det (Φ t) = Real.exp (∫ s in t₀..t, trace (A s)) * det (Φ t₀) := by
  sorry