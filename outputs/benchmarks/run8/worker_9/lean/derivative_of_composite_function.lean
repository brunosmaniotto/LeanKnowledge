import Mathlib

theorem Derivative_of_Composite_Function (f g h : ℝ → ℝ) (x : ℝ) (hh : ∀ x : ℝ, h x = (f ∘ g) x)
    (dg df : ℝ) (hg : HasDerivAt g dg x) (hf : HasDerivAt f df (g x)) : HasDerivAt h (df * dg) x := by
  have h_eq : h = f ∘ g := funext hh
  rw [h_eq]
  exact HasDerivAt.comp x hf hg