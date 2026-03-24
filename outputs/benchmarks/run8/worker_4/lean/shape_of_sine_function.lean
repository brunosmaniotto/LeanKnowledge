import Mathlib

open Real
open Set

theorem shape_of_sine_function :
    StrictMonoOn sin (Icc (-(π / 2)) (π / 2)) ∧
    StrictAntiOn sin (Icc (π / 2) (3 * π / 2)) ∧
    ConcaveOn ℝ (Icc 0 π) sin ∧
    ConvexOn ℝ (Icc π (2 * π)) sin := by
  constructor
  · intro x hx y hy hxy
    exact sin_lt_sin_of_lt_of_le_pi_div_two hx.1 hy.2 hxy
  constructor
  · intro x hx y hy hxy
    have hx1 : π / 2 ≤ x := hx.1
    have hx2 : x ≤ 3 * π / 2 := hx.2
    have hy1 : π / 2 ≤ y := hy.1
    have hy2 : y ≤ 3 * π / 2 := hy.2
    have hx' : -(π / 2) ≤ π - y := by linarith
    have hy' : π - x ≤ π / 2 := by linarith
    have h_ab : π - y < π - x := by linarith
    have H := sin_lt_sin_of_lt_of_le_pi_div_two hx' hy' h_ab
    rw [sin_pi_sub, sin_pi_sub] at H
    exact H
  constructor
  · exact strictConcaveOn_sin_Icc.concaveOn
  · let A : ℝ →ᵃ[ℝ] ℝ :=
      { toFun := fun x => x - π
        linear := LinearMap.id
        map_vadd' := by
          intro p v
          simp [add_sub_assoc] }
    have hA : ∀ x, A x = x - π := fun _ => rfl
    have h_preimage : A ⁻¹' Icc (0 : ℝ) π = Icc π (2 * π) := by
      ext x
      constructor
      · intro hx
        rcases hx with ⟨h1, h2⟩
        rw [hA x] at h1 h2
        constructor <;> linarith
      · intro hx
        rcases hx with ⟨h1, h2⟩
        have h1' : 0 ≤ A x := by rw [hA x]; linarith
        have h2' : A x ≤ π := by rw [hA x]; linarith
        exact ⟨h1', h2'⟩
    have h_concave : ConcaveOn ℝ (Icc 0 π) sin := strictConcaveOn_sin_Icc.concaveOn
    have h_concave_comp : ConcaveOn ℝ (A ⁻¹' Icc 0 π) (sin ∘ A) :=
      h_concave.comp_affineMap A
    rw [h_preimage] at h_concave_comp
    have h_comp_eq : sin ∘ A = -sin := by
      ext x
      exact sin_sub_pi x
    have h_concave_comp' : ConcaveOn ℝ (Icc π (2 * π)) (-sin) := by rwa [h_comp_eq] at h_concave_comp
    have h_convex : ConvexOn ℝ (Icc π (2 * π)) (-(-sin)) := h_concave_comp'.neg
    rw [neg_neg] at h_convex
    exact h_convex