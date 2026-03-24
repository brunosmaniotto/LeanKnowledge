import Mathlib

/-- By the Envelope theorem, ∂v(p,y)/∂y = λ* > 0, where λ* is the Lagrange multiplier
    at the optimum of the utility maximisation problem. Thus v(p,y) is strictly increasing in y. -/
theorem Claim_1_6_proof_c
    (v : ℝ → ℝ)
    (lam : ℝ)
    (hlam : lam > 0)
    (henv : ∀ y, HasDerivAt v lam y) :
    StrictMono v := by
  intro a b hab
  have hdiff : Differentiable ℝ v := fun x => (henv x).differentiableAt
  obtain ⟨c, _, hc⟩ := exists_hasDerivAt_eq_slope v (fun _ => lam) hab
    hdiff.continuous.continuousOn (fun x _ => henv x)
  rw [eq_div_iff (sub_pos.mpr hab).ne'] at hc
  linarith [mul_pos hlam (sub_pos.mpr hab)]