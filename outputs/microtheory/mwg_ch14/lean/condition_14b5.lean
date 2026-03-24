import Mathlib

noncomputable section

def ownerObjective (expectedProfit g v_inv : ℝ → ℝ) (u_bar : ℝ) (e : ℝ) : ℝ :=
  expectedProfit e - v_inv (u_bar + g e)