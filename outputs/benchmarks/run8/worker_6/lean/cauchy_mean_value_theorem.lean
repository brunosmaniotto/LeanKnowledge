import Mathlib

-- Axiomatized sub-lemmas (given as facts)

axiom g_b_ne_g_a_of_deriv_ne_zero {a b : ℝ} {g : ℝ → ℝ} (hab : a < b)
    (hgCont : ContinuousOn g (Set.Icc a b))
    (hgDiff : DifferentiableOn ℝ g (Set.Ioo a b))
    (hg' : ∀ x ∈ Set.Ioo a b, deriv g x ≠ 0) :
    g b ≠ g a

axiom exists_cauchy_mean_value_cross_multiplied {a b : ℝ} {f g : ℝ → ℝ} (hab : a < b)
    (hfCont : ContinuousOn f (Set.Icc a b)) (hgCont : ContinuousOn g (Set.Icc a b))
    (hfDiff : DifferentiableOn ℝ f (Set.Ioo a b)) (hgDiff : DifferentiableOn ℝ g (Set.Ioo a b)) :
    ∃ c ∈ Set.Ioo a b, (f b - f a) * deriv g c = (g b - g a) * deriv f c

-- Main theorem proof using the axioms

/--
The **Cauchy Mean Value Theorem**.
Let `f` and `g` be real functions which are continuous on the closed interval `[a, b]` and
differentiable on the open interval `(a, b)`. Suppose that for all `x` in `(a, b)`, `g'(x) ≠ 0`.
Then there exists a point `c` in `(a, b)` such that `f'(c) / g'(c) = (f(b) - f(a)) / (g(b) - g(a))`.
-/
theorem cauchy_mean_value_theorem
    {a b : ℝ} {f g : ℝ → ℝ} (hab : a < b)
    (hfCont : ContinuousOn f (Set.Icc a b)) (hgCont : ContinuousOn g (Set.Icc a b))
    (hfDiff : DifferentiableOn ℝ f (Set.Ioo a b)) (hgDiff : DifferentiableOn ℝ g (Set.Ioo a b))
    (hg' : ∀ x ∈ Set.Ioo a b, deriv g x ≠ 0) :
    ∃ c ∈ Set.Ioo a b, deriv f c / deriv g c = (f b - f a) / (g b - g a) := by
  -- From the axioms, we know `g b ≠ g a`.
  have h_gb_ne_ga : g b ≠ g a := g_b_ne_g_a_of_deriv_ne_zero hab hgCont hgDiff hg'
  -- From the axioms, we get the existence of a `c` satisfying the cross-multiplied equation.
  obtain ⟨c, hc_mem, h_cross_eq⟩ :=
    exists_cauchy_mean_value_cross_multiplied hab hfCont hgCont hfDiff hgDiff
  -- We propose this `c` as our witness.
  use c, hc_mem
  -- To perform the division, we need to show the denominators are non-zero.
  have hg'_c_ne_zero : deriv g c ≠ 0 := hg' c hc_mem
  have h_denom_ne_zero : g b - g a ≠ 0 := sub_ne_zero.mpr h_gb_ne_ga
  -- The equation `u / v = x / y` is equivalent to `u * y = x * v` if `v` and `y` are non-zero.
  rw [div_eq_div_iff hg'_c_ne_zero h_denom_ne_zero]
  -- Our goal is now `deriv f c * (g b - g a) = (f b - f a) * deriv g c`.
  -- Our hypothesis `h_cross_eq` is `(f b - f a) * deriv g c = (g b - g a) * deriv f c`.
  -- We can align the goal with the hypothesis using commutativity of multiplication.
  rw [mul_comm (deriv f c)]
  -- The goal is now `(g b - g a) * deriv f c = (f b - f a) * deriv g c`.
  -- This is the symmetric form of `h_cross_eq`.
  exact h_cross_eq.symm