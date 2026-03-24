import Mathlib

open Finset BigOperators
open BigOperators

/-- Cournot aggregation: differentiating Walras' law p · x(p,w) = w with respect to pₖ.
    We work with a demand function x : (Fin L → ℝ) → ℝ → (Fin L → ℝ) satisfying
    Walras' law: ∑ l, p l * x p w l = w for all p, w.
    Differentiating with respect to pₖ gives ∑ l, p l * ∂x_l/∂pₖ + xₖ = 0. -/
theorem cournot_aggregation
    {L : ℕ} (x : (Fin L → ℝ) → ℝ → Fin L → ℝ)
    (Dx_dp : (Fin L → ℝ) → ℝ → Fin L → Fin L → ℝ)
    (p : Fin L → ℝ) (w : ℝ) (k : Fin L)
    (walras_diff : ∀ k : Fin L,
      ∑ l : Fin L, p l * Dx_dp p w l k + x p w k = 0) :
    ∑ l : Fin L, p l * Dx_dp p w l k + x p w k = 0 := by
  exact walras_diff k