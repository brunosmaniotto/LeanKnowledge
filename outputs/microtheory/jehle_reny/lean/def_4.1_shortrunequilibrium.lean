import Mathlib

/-- A competitive market is in short-run equilibrium at price `p_star` when
    market demand equals market supply: `qd(p_star) = qs(p_star)`. -/
def ShortRunEquilibrium (qd qs : ℝ → ℝ) (p_star : ℝ) : Prop :=
  qd p_star = qs p_star