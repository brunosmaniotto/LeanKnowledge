import Mathlib

open Real

theorem equilibrium_foc_bidder1
    (y₂ : ℝ → ℝ) (y₂' : ℝ → ℝ) (v₁ x : ℝ)
    (hy₂_deriv : HasDerivAt y₂ (y₂' x) x)
    (h_foc : deriv (fun b => (v₁ - b) * y₂ b) x = 0) :
    -y₂ x + (v₁ - x) * y₂' x = 0 := by
  have h1 : HasDerivAt (fun b => v₁ - b) (-1) x := by
    have := (hasDerivAt_const x v₁).sub (hasDerivAt_id x)
    simp at this
    convert this using 1 <;> ring
  have hd : HasDerivAt (fun b => (v₁ - b) * y₂ b) (-1 * y₂ x + (v₁ - x) * y₂' x) x := by
    exact h1.mul hy₂_deriv
  have heq : -1 * y₂ x + (v₁ - x) * y₂' x = -y₂ x + (v₁ - x) * y₂' x := by ring
  rw [heq] at hd
  rw [hd.deriv] at h_foc
  linarith