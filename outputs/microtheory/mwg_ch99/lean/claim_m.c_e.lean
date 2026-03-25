import Mathlib
open Topology

noncomputable section

/-- A C² function on ℝ is concave iff its second derivative is nonpositive everywhere. -/
axiom concave_iff_second_deriv_nonpos (f : ℝ → ℝ) (hf : ContDiff ℝ 2 f) :
    ConcaveOn ℝ Set.univ f ↔ ∀ x : ℝ, deriv (deriv f) x ≤ 0

/-- If the second derivative is strictly negative everywhere, the function is strictly concave. -/
axiom strict_concave_of_second_deriv_neg (f : ℝ → ℝ) (hf : ContDiff ℝ 2 f)
    (h : ∀ x : ℝ, deriv (deriv f) x < 0) :
    StrictConcaveOn ℝ Set.univ f

/-- Claim M.C.e: In dimension N = 1, concavity is equivalent to f'' ≤ 0,
    and f'' < 0 implies strict concavity. -/
theorem claim_M_C_e (f : ℝ → ℝ) (hf : ContDiff ℝ 2 f) :
    (ConcaveOn ℝ Set.univ f ↔ ∀ x : ℝ, deriv (deriv f) x ≤ 0) ∧
    ((∀ x : ℝ, deriv (deriv f) x < 0) → StrictConcaveOn ℝ Set.univ f) :=
  ⟨concave_iff_second_deriv_nonpos f hf, strict_concave_of_second_deriv_neg f hf⟩

end