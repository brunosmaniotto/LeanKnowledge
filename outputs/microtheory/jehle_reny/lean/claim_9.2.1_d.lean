import Mathlib
open Topology

noncomputable section

axiom b_hat : ℝ → ℝ
axiom b_hat_differentiable : Differentiable ℝ b_hat
axiom b_hat_deriv_pos : ∀ x : ℝ, 0 < deriv b_hat x

theorem Claim_9_2_1_d : StrictMono b_hat := by
  intro a b hab
  have hcont : ContinuousOn b_hat (Set.Icc a b) :=
    b_hat_differentiable.continuous.continuousOn
  have hderiv : ∀ x ∈ Set.Ioo a b, HasDerivAt b_hat (deriv b_hat x) x :=
    fun x _ ↦ (b_hat_differentiable x).hasDerivAt
  obtain ⟨c, _, hc⟩ := exists_hasDerivAt_eq_slope b_hat
    (fun x ↦ deriv b_hat x) hab hcont hderiv
  have hba : (0 : ℝ) < b - a := sub_pos.mpr hab
  have hne : (b - a) ≠ 0 := ne_of_gt hba
  have hdc := b_hat_deriv_pos c
  rw [hc] at hdc
  have h := mul_pos hdc hba
  have hsimpl : (b_hat b - b_hat a) / (b - a) * (b - a) = b_hat b - b_hat a := by
    field_simp
  rw [hsimpl] at h
  linarith