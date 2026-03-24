import Mathlib

theorem claim_13C_i
    (θ_L θ_H : ℝ)
    (hθ : θ_L < θ_H)
    (lam : ℝ)
    (hlam_pos : 0 < lam)
    (hlam_lt : lam < 1)
    (c_sep : ℝ)
    (hc_pos : 0 < c_sep)
    : ∃ W_L W_H : ℝ,
        W_L > θ_L ∧
        W_H > θ_H - c_sep ∧
        (1 - lam) * W_L + lam * W_H = (1 - lam) * θ_L + lam * θ_H := by
  refine ⟨θ_L + lam * c_sep / 2, θ_H - (1 - lam) * c_sep / 2, ?_, ?_, ?_⟩
  · nlinarith
  · nlinarith
  · ring