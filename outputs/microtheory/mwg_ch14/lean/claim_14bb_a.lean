import Mathlib

structure KuhnTuckerBB where
  lam : ℝ
  hlam_pos : 0 < lam
  hlam_lt : lam < 1
  e_H : ℝ
  e_L : ℝ
  phi_H : ℝ
  phi_L : ℝ
  gamma : ℝ
  pi' : ℝ → ℝ
  g_e : ℝ → ℝ → ℝ
  kt_mult : -lam + phi_H - phi_L = 0
  kt_gamma : gamma = 1
  he_H_pos : e_H > 0
  he_L_pos : e_L > 0
  hphi_H_nonneg : phi_H ≥ 0
  hphi_L_nonneg : phi_L ≥ 0
  hphi_L_zero : phi_L = 0
  foc_eH : pi' e_H - g_e e_H 0 = 0
  foc_eL : (pi' e_L - g_e e_L 1) + (lam / (1 - lam)) * (g_e e_L 0 - g_e e_L 1) = 0

theorem Claim_14BB_a (P : KuhnTuckerBB) :
    P.phi_H > 0 ∧ P.gamma = 1 ∧ P.e_H > 0 ∧ P.e_L > 0 ∧ P.phi_L = 0 ∧
    P.phi_H = P.lam ∧
    P.pi' P.e_H - P.g_e P.e_H 0 = 0 ∧
    (P.pi' P.e_L - P.g_e P.e_L 1) + (P.lam / (1 - P.lam)) * (P.g_e P.e_L 0 - P.g_e P.e_L 1) = 0 := by
  refine ⟨?_, P.kt_gamma, P.he_H_pos, P.he_L_pos, P.hphi_L_zero, ?_, P.foc_eH, P.foc_eL⟩
  · linarith [P.kt_mult, P.hphi_L_zero, P.hlam_pos]
  · linarith [P.kt_mult, P.hphi_L_zero]