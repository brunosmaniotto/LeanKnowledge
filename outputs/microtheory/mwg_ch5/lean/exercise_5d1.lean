import Mathlib
open Topology

theorem Exercise_5D1
    (C : ℝ → ℝ) (qbar : ℝ) (hq : qbar > 0)
    (hC : DifferentiableAt ℝ C qbar)
    (hmin : IsLocalMin (fun q => C q / q) qbar) :
    C qbar / qbar = deriv C qbar := by
  have hq_ne : qbar ≠ 0 := ne_of_gt hq
  have hderiv_zero : deriv (fun q => C q / q) qbar = 0 :=
    hmin.deriv_eq_zero
  have hC_at : HasDerivAt C (deriv C qbar) qbar := hC.hasDerivAt
  have hid_at : HasDerivAt id 1 qbar := hasDerivAt_id qbar
  have hquot : HasDerivAt (fun q => C q / q)
      ((deriv C qbar * qbar - C qbar * 1) / qbar ^ 2) qbar :=
    hC_at.div hid_at (by simp [hq_ne])
  have hderiv_eq : deriv (fun q => C q / q) qbar =
      (deriv C qbar * qbar - C qbar) / qbar ^ 2 := by
    have := hquot.deriv
    simp [mul_one] at this
    exact this
  rw [hderiv_eq] at hderiv_zero
  have hsq_ne : qbar ^ 2 ≠ 0 := pow_ne_zero 2 hq_ne
  have h1 : deriv C qbar * qbar - C qbar = 0 := by
    rcases (div_eq_zero_iff.mp hderiv_zero) with h | h
    · exact h
    · exact absurd h hsq_ne
  have h2 : C qbar = deriv C qbar * qbar := by linarith
  rw [h2, mul_div_cancel_of_imp]
  intro h; exact absurd h hq_ne