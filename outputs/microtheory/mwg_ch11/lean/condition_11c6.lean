import Mathlib
set_option linter.unusedVariables false

axiom step1_boundary_foc (f : ℝ → ℝ) (hf : DifferentiableAt ℝ f 0) (hmax : ∀ y : ℝ, 0 ≤ y → f y ≤ f 0) : deriv f 0 ≤ 0
axiom step2_interior_foc (f : ℝ → ℝ) (x : ℝ) (hf : DifferentiableAt ℝ f x) (hmax : IsLocalMax f x) : deriv f x = 0
axiom step3_obj_deriv_eq (φ : ℝ → ℝ) (p x : ℝ) (hφ : DifferentiableAt ℝ φ x) : deriv (fun y => φ y - p * y) x = deriv φ x - p
axiom step4_global_to_local_max (f : ℝ → ℝ) (x : ℝ) (hx : 0 < x) (hmax : ∀ y : ℝ, 0 ≤ y → f y ≤ f x) : IsLocalMax f x

theorem Condition_11C6
    (φ : ℝ → ℝ) (p x : ℝ)
    (hx_nn : 0 ≤ x)
    (hφ : DifferentiableAt ℝ φ x)
    (hobj_max : ∀ y : ℝ, 0 ≤ y → φ y - p * y ≤ φ x - p * x) :
    deriv φ x ≤ p ∧ (0 < x → deriv φ x = p) := by
  have hobj_diff : DifferentiableAt ℝ (fun y => φ y - p * y) x :=
    hφ.sub ((differentiableAt_const p).mul differentiableAt_id)
  have hd3 : deriv (fun y => φ y - p * y) x = deriv φ x - p :=
    step3_obj_deriv_eq φ p x hφ
  by_cases hx_pos : 0 < x
  · have hloc : IsLocalMax (fun y => φ y - p * y) x :=
      step4_global_to_local_max (fun y => φ y - p * y) x hx_pos hobj_max
    have heq : deriv (fun y => φ y - p * y) x = 0 :=
      step2_interior_foc (fun y => φ y - p * y) x hobj_diff hloc
    have hφp : deriv φ x = p := by linarith [hd3, heq]
    exact ⟨le_of_eq hφp, fun _ => hφp⟩
  · have hx_zero : x = 0 := le_antisymm (not_lt.mp hx_pos) hx_nn
    subst hx_zero
    have hle : deriv (fun y => φ y - p * y) 0 ≤ 0 :=
      step1_boundary_foc (fun y => φ y - p * y) hobj_diff hobj_max
    exact ⟨by linarith [hd3, hle], fun h => absurd h (lt_irrefl 0)⟩