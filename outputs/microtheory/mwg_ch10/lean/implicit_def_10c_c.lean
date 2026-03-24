import Mathlib
open Topology

noncomputable section

/--
Properties of a quasi-linear utility component φ_i that guarantee
a well-defined Walrasian demand function.
-/
structure WalrasianUtilityProps (φ : ℝ → ℝ) : Prop where
  twice_diff : Differentiable ℝ (deriv φ)
  strict_concave : ∀ x : ℝ, deriv (deriv φ) x < 0
  deriv_pos_at_zero : deriv φ 0 > 0

/--
Consumer i's Walrasian demand function for good ℓ.
Given utility component φ with `WalrasianUtilityProps`:
- When p < φ'(0), returns the unique x such that φ'(x) = p.
- When p ≥ φ'(0), returns 0.
The function is continuous and nonincreasing in p, strictly decreasing for p < φ'(0).
-/
noncomputable def walrasianDemand (φ : ℝ → ℝ) (hφ : WalrasianUtilityProps φ) (p : ℝ) : ℝ :=
  if p < deriv φ 0 then
    Classical.epsilon (fun x => deriv φ x = p ∧ x ≥ 0)
  else
    0