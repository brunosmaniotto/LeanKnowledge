import Mathlib

open Real

theorem first_order_reaction_solution (x0 k : ℝ) :
    let x : ℝ → ℝ := fun t => x0 * exp (-k * t); x 0 = x0 ∧ ∀ t, HasDerivAt x (-k * x t) t := by
  intro x
  have h0 : x 0 = x0 := by simp [x]
  have h_deriv : ∀ t, HasDerivAt x (-k * x t) t := by
    intro t
    dsimp [x]
    have h_linear : HasDerivAt (fun t : ℝ => -k * t) (-k) t := by
      convert HasDerivAt.const_mul (-k) (hasDerivAt_id t) using 1
      ring
    have h_exp : HasDerivAt exp (exp (-k * t)) (-k * t) := Real.hasDerivAt_exp (-k * t)
    have h_chain : HasDerivAt (fun t : ℝ => exp (-k * t)) (-k * exp (-k * t)) t := by
      convert HasDerivAt.comp t h_exp h_linear using 1
      ring
    have h_mul : HasDerivAt (fun t : ℝ => x0 * exp (-k * t)) (x0 * (-k * exp (-k * t))) t :=
      HasDerivAt.const_mul x0 h_chain
    have H : x0 * (-k * exp (-k * t)) = -k * (x0 * exp (-k * t)) := by ring
    rw [H] at h_mul
    exact h_mul
  exact ⟨h0, h_deriv⟩