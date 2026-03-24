import Mathlib

/-- A separating equilibrium comparison between two low-risk contracts. -/
structure SepEquilPair where
  u_l_old : ℝ
  u_l_new : ℝ
  u_h : ℝ
  π_old : ℝ
  π_new : ℝ
  same_profit : π_old = π_new
  low_strict_pref : u_l_new > u_l_old

/-- Pareto dominance: no agent worse off, at least one strictly better. -/
def paretoDominates (S : SepEquilPair) : Prop :=
  S.u_l_new ≥ S.u_l_old ∧
  S.u_h ≥ S.u_h ∧
  S.π_new ≥ S.π_old ∧
  (S.u_l_new > S.u_l_old ∨ S.π_new > S.π_old)