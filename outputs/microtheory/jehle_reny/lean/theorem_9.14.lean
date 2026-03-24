import Mathlib

open Set
open Real
open Topology
set_option linter.unusedVariables false

theorem Theorem_9_14 {c₁ c₂ : ℝ → ℝ}
    (h_cont_c1 : ContinuousOn c₁ (Icc 0 1))
    (h_cont_c2 : ContinuousOn c₂ (Icc 0 1))
    (h_diff1 : DifferentiableOn ℝ c₁ (Ioo 0 1))
    (h_diff2 : DifferentiableOn ℝ c₂ (Ioo 0 1))
    (h_deriv_eq : ∀ t ∈ Ioo (0 : ℝ) 1, deriv c₁ t = deriv c₂ t) :
    ∃ C : ℝ, ∀ t ∈ Icc (0 : ℝ) 1, c₁ t - c₂ t = C := by
  set f := c₁ - c₂ with hf_def
  have h_cont_f : ContinuousOn f (Icc 0 1) := h_cont_c1.sub h_cont_c2
  have h_diff_f : DifferentiableOn ℝ f (Ioo 0 1) := h_diff1.sub h_diff2
  have h_deriv_f : ∀ t ∈ Ioo (0 : ℝ) 1, deriv f t = 0 := by
    intro t ht
    have h1 : DifferentiableAt ℝ c₁ t := h_diff1.differentiableAt (isOpen_Ioo.mem_nhds ht)
    have h2 : DifferentiableAt ℝ c₂ t := h_diff2.differentiableAt (isOpen_Ioo.mem_nhds ht)
    rw [deriv_sub h1 h2, h_deriv_eq t ht, sub_self]
  refine ⟨f 0, ?_⟩
  intro t ht
  by_cases h : t = 0
  · simp [h, f]
  · have hpos : 0 < t := lt_of_le_of_ne ht.1 (Ne.symm h)
    have h_cont : ContinuousOn f (Icc 0 t) :=
      h_cont_f.mono (Icc_subset_Icc_right ht.2)
    have h_diff : DifferentiableOn ℝ f (Ioo 0 t) :=
      h_diff_f.mono (Ioo_subset_Ioo (le_refl 0) ht.2)
    rcases exists_deriv_eq_slope f hpos h_cont h_diff with ⟨c, hc, hc'⟩
    have h_deriv_zero : deriv f c = 0 := h_deriv_f c ⟨hc.1, lt_of_lt_of_le hc.2 ht.2⟩
    rw [h_deriv_zero] at hc'
    field_simp [ne_of_gt hpos] at hc'
    simp [f] at hc' ⊢
    linarith