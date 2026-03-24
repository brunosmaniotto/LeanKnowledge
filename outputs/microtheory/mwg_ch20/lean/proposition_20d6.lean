import Mathlib
set_option linter.unusedVariables false

/-- The planning problem (20.D.7) has at most one consumption stream solution.
    Abstract form: a strictly concave functional on a convex feasible set has at most one maximizer. -/
theorem Proposition_20D6 {E : Type*} [AddCommGroup E] [Module ℝ E]
    {f : E → ℝ} {s : Set E}
    (hf : StrictConcaveOn ℝ s f)
    {x y : E}
    (hx : x ∈ s) (hy : y ∈ s)
    (hfx : ∀ z ∈ s, f z ≤ f x)
    (hfy : ∀ z ∈ s, f z ≤ f y) :
    x = y := by
  by_contra hne
  -- The midpoint of x and y lies in s by convexity of the feasible set
  have hmid : (1 / 2 : ℝ) • x + (1 / 2 : ℝ) • y ∈ s :=
    hf.1 hx hy (by norm_num) (by norm_num) (by norm_num)
  -- Strict concavity: f(midpoint) strictly exceeds the weighted average of f-values
  have hstrict : (1 / 2 : ℝ) * f x + (1 / 2 : ℝ) * f y <
      f ((1 / 2 : ℝ) • x + (1 / 2 : ℝ) • y) := by
    have h := hf.2 hx hy hne
      (by norm_num : (0 : ℝ) < 1 / 2)
      (by norm_num : (0 : ℝ) < 1 / 2)
      (by norm_num : (1 / 2 : ℝ) + 1 / 2 = 1)
    simpa [smul_eq_mul] using h
  -- Both x and y maximize f, so f(midpoint) ≤ f x and f(midpoint) ≤ f y
  -- Combined with hstrict this gives (fx + fy)/2 < fx and (fx + fy)/2 < fy,
  -- i.e. fy < fx and fx < fy — a contradiction.
  linarith [hfx _ hmid, hfy _ hmid]