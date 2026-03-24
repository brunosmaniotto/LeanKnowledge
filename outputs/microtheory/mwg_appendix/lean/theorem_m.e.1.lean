import Mathlib

open Matrix

theorem implicit_function_theorem_comparative_statics
    {N M : ℕ}
    (Dx_f : Matrix (Fin N) (Fin N) ℝ)
    (Dq_f : Matrix (Fin N) (Fin M) ℝ)
    (Dq_η : Matrix (Fin N) (Fin M) ℝ)
    (h_det : IsUnit Dx_f.det)
    (h_chain_rule : Dx_f * Dq_η + Dq_f = 0) :
    Dq_η = -Dx_f⁻¹ * Dq_f := by
  have h1 : Dx_f * Dq_η = -Dq_f := eq_neg_of_add_eq_zero_left h_chain_rule
  have h2 : Dx_f⁻¹ * (Dx_f * Dq_η) = Dx_f⁻¹ * -Dq_f := by rw [h1]
  rw [← Matrix.mul_assoc, Matrix.nonsing_inv_mul _ h_det, Matrix.one_mul] at h2
  rw [h2]
  simp [neg_mul, mul_neg]