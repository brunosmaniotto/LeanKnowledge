import Mathlib

noncomputable section

structure MoralHazardKT where
  v' : ℝ → ℝ
  w : ℝ → ℝ
  f_H : ℝ → ℝ
  f_L : ℝ → ℝ
  g_H : ℝ
  g_L : ℝ
  γ : ℝ
  μ : ℝ
  hγ_pos : γ > 0
  hμ_pos : μ > 0
  hf_H_pos : ∀ π, f_H π > 0
  hv'_pos : ∀ π, v' (w π) > 0

def MoralHazardKT.ICHolds (P : MoralHazardKT) (E_vw_H E_vw_L : ℝ) : Prop :=
  E_vw_H - P.g_H ≥ E_vw_L - P.g_L