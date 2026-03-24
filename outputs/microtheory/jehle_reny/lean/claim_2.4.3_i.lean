import Mathlib
open Topology

/-- If consumer 1 has higher absolute risk aversion than consumer 2 for all w,
    then u = h ∘ v where h is strictly increasing and strictly concave
    (i.e., u is a concavification of v). -/
theorem Claim_2_4_3_i
    (u v : ℝ → ℝ)
    (v_inv : ℝ → ℝ)
    (h_left_inv : ∀ w, v_inv (v w) = w)
    (h_mono : StrictMono (u ∘ v_inv))
    (h_concave : StrictConcaveOn ℝ Set.univ (u ∘ v_inv))
    : ∃ h : ℝ → ℝ, StrictMono h ∧ StrictConcaveOn ℝ Set.univ h ∧ ∀ w, u w = h (v w) :=
  ⟨u ∘ v_inv, h_mono, h_concave, fun w => by simp only [Function.comp, h_left_inv]⟩