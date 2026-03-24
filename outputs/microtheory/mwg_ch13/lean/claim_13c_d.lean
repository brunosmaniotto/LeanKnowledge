import Mathlib

theorem Claim_13C_d
    (tL tH lam : ℝ)
    (hL_pos : 0 < tL)
    (hLH : tL < tH)
    (hlam_pos : 0 < lam)
    (hlam_lt : lam < 1) :
    tL < lam * tH + (1 - lam) * tL ∧
    (∃ c : ℝ, 0 < c ∧ tH - c > lam * tH + (1 - lam) * tL) ∧
    (∃ c : ℝ, 0 < c ∧ tH - c < lam * tH + (1 - lam) * tL) := by
  have hd : 0 < tH - tL := by linarith
  have hld : 0 < lam * (tH - tL) := by positivity
  have h1mlam : 0 < 1 - lam := by linarith
  refine ⟨by nlinarith, ?_, ?_⟩
  · exact ⟨(1 - lam) * (tH - tL) / 2, by positivity, by nlinarith⟩
  · exact ⟨tH, by linarith, by nlinarith⟩