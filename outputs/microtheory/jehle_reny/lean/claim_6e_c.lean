import Mathlib

open Finset BigOperators
open Topology

/-- If a transformation ψ : ℝ → ℝ preserves percentage changes (i.e., ratios of utility
    values) for all positive utility levels, then ψ must be a positive linear function
    ψ(x) = b * x for some b > 0. This formalizes MWG Claim 6.E: only common linear
    transformations ψ(uᵢ) = b · uᵢ (b > 0) preserve orderings of percentage changes
    in utility both within and across individuals. -/
theorem Claim_6E_c
    (ψ : ℝ → ℝ)
    (hψ_pos : ∀ x : ℝ, 0 < x → 0 < ψ x)
    (hψ_ratio : ∀ x y : ℝ, 0 < x → 0 < y → ψ x / ψ y = x / y) :
    ∃ b : ℝ, 0 < b ∧ ∀ x : ℝ, 0 < x → ψ x = b * x := by
  refine ⟨ψ 1, hψ_pos 1 one_pos, fun x hx => ?_⟩
  have h1 : 0 < ψ 1 := hψ_pos 1 one_pos
  have hx' : 0 < ψ x := hψ_pos x hx
  have := hψ_ratio x 1 hx one_pos
  rw [div_one] at this
  field_simp at this
  linarith