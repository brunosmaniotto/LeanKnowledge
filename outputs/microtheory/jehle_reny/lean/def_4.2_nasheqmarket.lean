import Mathlib

noncomputable section

def partialDeriv {J : ℕ} (f : (Fin J → ℝ) → ℝ) (k : Fin J) (q : Fin J → ℝ) : ℝ :=
  deriv (fun t => f (Function.update q k t)) (q k)