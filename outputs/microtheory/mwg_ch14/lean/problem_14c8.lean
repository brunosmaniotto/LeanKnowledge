import Mathlib

structure OwnerProblem14C8 where
  lam : ℝ
  hlam : lam ∈ Set.Ioo 0 1
  π : ℝ → ℝ
  g : ℝ → ℝ → ℝ
  θ_H : ℝ
  θ_L : ℝ
  v_inv_ubar : ℝ

structure Contract14C8 where
  w_H : ℝ
  e_H : ℝ
  w_L : ℝ
  e_L : ℝ
  hw_H : 0 ≤ w_H
  he_H : 0 ≤ e_H
  hw_L : 0 ≤ w_L
  he_L : 0 ≤ e_L

noncomputable def OwnerProblem14C8.objective (P : OwnerProblem14C8) (c : Contract14C8) : ℝ :=
  P.lam * (P.π c.e_H - c.w_H) + (1 - P.lam) * (P.π c.e_L - c.w_L)

def OwnerProblem14C8.IsFeasible (P : OwnerProblem14C8) (c : Contract14C8) : Prop :=
  c.w_L - P.g c.e_L P.θ_L ≥ P.v_inv_ubar ∧
  c.w_H - P.g c.e_H P.θ_H ≥ P.v_inv_ubar ∧
  c.w_H - P.g c.e_H P.θ_H ≥ c.w_L - P.g c.e_L P.θ_H ∧
  c.w_L - P.g c.e_L P.θ_L ≥ c.w_H - P.g c.e_H P.θ_L