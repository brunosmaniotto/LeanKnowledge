import Mathlib

theorem arrow_pratt_characterizes_utility
    (u₁ u₂ : ℝ → ℝ)
    (hu₁ : Differentiable ℝ u₁) (hu₂ : Differentiable ℝ u₂)
    (hu₁' : Differentiable ℝ (deriv u₁)) (hu₂' : Differentiable ℝ (deriv u₂))
    (h_pos₁ : ∀ x, deriv u₁ x > 0) (h_pos₂ : ∀ x, deriv u₂ x > 0)
    (h_same_rA : ∀ x, deriv (deriv u₁) x / deriv u₁ x =
                       deriv (deriv u₂) x / deriv u₂ x) :
    ∃ a b : ℝ, a > 0 ∧ ∀ x, deriv u₂ x = a * deriv u₁ x := by
  have h1 : ∀ x, deriv u₁ x ≠ 0 := fun x => ne_of_gt (h_pos₁ x)
  have h2 : ∀ x, deriv u₂ x ≠ 0 := fun x => ne_of_gt (h_pos₂ x)
  set g : ℝ → ℝ := fun x => deriv u₂ x / deriv u₁ x
  have hg_hd : ∀ x, HasDerivAt g 0 x := by
    intro x
    have hd1 := hu₁'.differentiableAt.hasDerivAt (x := x)
    have hd2 := hu₂'.differentiableAt.hasDerivAt (x := x)
    have hdiv := hd2.div hd1 (h1 x)
    have heq := h_same_rA x
    rw [div_eq_div_iff (h1 x) (h2 x)] at heq
    have hnum : deriv (deriv u₂) x * deriv u₁ x -
        deriv u₂ x * deriv (deriv u₁) x = 0 := by linarith
    simp only [hnum, zero_div] at hdiv
    exact hdiv
  have hg_diff : Differentiable ℝ g := fun y => (hg_hd y).differentiableAt
  have hg_const : ∀ x y, g x = g y :=
    is_const_of_deriv_eq_zero hg_diff (fun y => (hg_hd y).deriv)
  exact ⟨g 0, 0, div_pos (h_pos₂ 0) (h_pos₁ 0), fun x => by
    have hc : deriv u₂ x / deriv u₁ x = g 0 := hg_const x 0
    exact (div_eq_iff (h1 x)).mp hc⟩