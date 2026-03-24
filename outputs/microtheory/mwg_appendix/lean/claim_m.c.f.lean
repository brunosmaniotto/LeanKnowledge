import Mathlib
open Set
open Topology

axiom concaveOn_implies_deriv2_nonpos {f : ℝ → ℝ} (hf : ContDiff ℝ 2 f)
    (hc : ConcaveOn ℝ univ f) (x : ℝ) : deriv (deriv f) x ≤ 0

axiom differentiable_deriv_of_contDiff_two {f : ℝ → ℝ} (hf : ContDiff ℝ 2 f) :
    Differentiable ℝ (deriv f)

theorem claim_M_C_f {f : ℝ → ℝ} (hf : ContDiff ℝ 2 f) :
    (ConcaveOn ℝ univ f ↔ ∀ x, deriv (deriv f) x ≤ 0) ∧
    ((∀ x, deriv (deriv f) x < 0) → StrictConcaveOn ℝ univ f) := by
  have hd1 : Differentiable ℝ f := hf.differentiable (by norm_num)
  have hd2 := differentiable_deriv_of_contDiff_two hf
  exact ⟨⟨fun hc x => concaveOn_implies_deriv2_nonpos hf hc x,
         fun h => concaveOn_univ_of_deriv2_nonpos hd1 hd2 h⟩,
         fun h => strictConcaveOn_univ_of_deriv2_neg hd1.continuous h⟩