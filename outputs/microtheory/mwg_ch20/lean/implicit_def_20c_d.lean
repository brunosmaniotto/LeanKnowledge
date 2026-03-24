import Mathlib
open BigOperators

/-- The profit level at time `t` for a production plan in the intertemporal setting.
    Given present-value prices `p : ℕ → Fin L → ℝ` and production vectors
    `y_b` (beginning-of-period inputs) and `y_a` (end-of-period outputs),
    the profit at period `t` is `π_t = p_t · y_{b,t} + p_{t+1} · y_{a,t}`. -/
noncomputable def intertemporalProfit (L : ℕ) (p : ℕ → Fin L → ℝ)
    (y_b : ℕ → Fin L → ℝ) (y_a : ℕ → Fin L → ℝ) (t : ℕ) : ℝ :=
  ∑ i : Fin L, p t i * y_b t i + ∑ i : Fin L, p (t + 1) i * y_a t i