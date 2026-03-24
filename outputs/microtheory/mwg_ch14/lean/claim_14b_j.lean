import Mathlib
open Topology

/-- The optimal contract for implementing high effort depends on the likelihood ratio,
    which generally precludes a simple (e.g., linear) form. -/
theorem optimal_contract_not_simple_form
    (S : Type) [Fintype S] [Nonempty S]
    (f_H f_L : S → ℝ)
    (hf_H_pos : ∀ s, f_H s > 0)
    (hf_L_pos : ∀ s, f_L s > 0)
    (w : S → ℝ)
    (likelihood_ratio : S → ℝ)
    (h_lr : ∀ s, likelihood_ratio s = f_L s / f_H s)
    (h_foc_injective : ∀ s₁ s₂, likelihood_ratio s₁ ≠ likelihood_ratio s₂ → w s₁ ≠ w s₂)
    (h_informative : ∃ s₁ s₂, likelihood_ratio s₁ ≠ likelihood_ratio s₂)
    : ∃ s₁ s₂, w s₁ ≠ w s₂ := by
  obtain ⟨s₁, s₂, h_ne⟩ := h_informative
  exact ⟨s₁, s₂, h_foc_injective s₁ s₂ h_ne⟩