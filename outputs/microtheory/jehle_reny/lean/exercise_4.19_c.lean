import Mathlib
open Topology

theorem exercise_4_19_c (p w : ℝ) (hp : p ≠ 0) :
    deriv (fun p' : ℝ => p'⁻¹) p = -(p ^ 2)⁻¹ ∧
    deriv (fun _ : ℝ => p⁻¹) w = 0 ∧
    p⁻¹ * deriv (fun _ : ℝ => p⁻¹) w = 0 := by
  refine ⟨?_, deriv_const w p⁻¹, by rw [deriv_const w p⁻¹]; ring⟩
  have h : deriv (fun p' : ℝ => p'⁻¹) p = -1 / p ^ 2 :=
    ((hasDerivAt_id p).inv hp).deriv
  rw [h]; ring