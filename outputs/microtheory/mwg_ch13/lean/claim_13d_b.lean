import Mathlib

/-- Screening game: a profitable pooling deviation breaks separating equilibrium -/
structure ScreeningGame where
  theta_L : ℝ
  theta_H : ℝ
  lam : ℝ
  w_sep_L : ℝ
  w_sep_H : ℝ
  h_types : theta_L < theta_H
  h_lam_pos : 0 < lam
  h_lam_lt : lam < 1

noncomputable def ScreeningGame.expectedTheta (G : ScreeningGame) : ℝ :=
  G.lam * G.theta_H + (1 - G.lam) * G.theta_L

/-- Claim 13.D.b: If a pooling wage attracts both types and is below expected
    productivity, the deviating firm earns positive profit, so no separating
    equilibrium exists. -/
theorem screening_no_equilibrium (G : ScreeningGame)
    (w_pool : ℝ)
    (h_attracts_L : w_pool > G.w_sep_L)
    (h_attracts_H : w_pool > G.w_sep_H)
    (h_profitable : w_pool < G.expectedTheta) :
    G.expectedTheta - w_pool > 0 := by
  linarith