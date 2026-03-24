import Mathlib

open Set

theorem zero_deriv_implies_constant {f : ℝ → ℝ} {a b : ℝ} (hcont : ContinuousOn f (Icc a b))
    (hdiff : DifferentiableOn ℝ f (Ioo a b)) (hderiv : ∀ x ∈ Ioo a b, deriv f x = 0) :
    ∀ x ∈ Icc a b, f x = f a := by
  intro x hx
  rcases hx with ⟨hax, hxb⟩
  by_cases h : a < x
  · have hx_le : x ≤ b := hxb
    obtain ⟨ξ, hξ, H⟩ := exists_deriv_eq_slope f h (hcont.mono (Icc_subset_Icc_right hx_le)) 
      (hdiff.mono (Ioo_subset_Ioo_right hx_le))
    have hξ' : ξ ∈ Ioo a b := ⟨hξ.1, lt_of_lt_of_le hξ.2 hx_le⟩
    have hderiv0 : deriv f ξ = 0 := hderiv ξ hξ'
    have H1 : (f x - f a) / (x - a) = 0 := by linarith
    have hpos : 0 < x - a := sub_pos_of_lt h
    rcases div_eq_zero_iff.mp H1 with (h2 | h3)
    · linarith
    · linarith
  · have hx_le : x ≤ a := by linarith
    have hx_eq : x = a := le_antisymm hx_le hax
    rw [hx_eq]