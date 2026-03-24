import Mathlib

open MeasureTheory Set

noncomputable section

theorem Claim_9_4_4_c
    (p c : ℝ → ℝ)
    (v : ℝ) (hv : 0 ≤ v)
    (h_mono : Monotone p)
    (h_p_nonneg : ∀ x, 0 ≤ p x)
    (h_payment : c v = p v * v - ∫ x in (0:ℝ)..v, p x)
    (h_no_object : p v = 0) :
    c v = 0 := by
  have h_pzero : ∀ x, x ≤ v → p x = 0 := by
    intro x hx
    have h1 : p x ≤ p v := h_mono hx
    rw [h_no_object] at h1
    exact le_antisymm h1 (h_p_nonneg x)
  have h_int : ∫ x in (0:ℝ)..v, p x = 0 := by
    have hcongr : EqOn p (fun _ => (0:ℝ)) (uIcc 0 v) := by
      intro x hx
      simp only [mem_uIcc] at hx
      rcases hx with ⟨_, hxv⟩ | ⟨_, hx0⟩
      · exact h_pzero x hxv
      · exact h_pzero x (hx0.trans hv)
    rw [intervalIntegral.integral_congr hcongr]
    simp
  rw [h_payment, h_no_object, h_int]
  ring