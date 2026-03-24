import Mathlib

/-- If preferences are complete, convex (upper contour sets are convex), and transitive,
    then the strict upper contour set V_i = {x_i : x_i ≻_i x*_i} is convex. -/
theorem Claim_16D_step1
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (pref : E → E → Prop)  -- x ≿ y
    (hTrans : Transitive pref)
    (hComplete : ∀ x y, pref x y ∨ pref y x)
    -- Convexity of preferences: upper contour sets {z : pref z y} are convex
    (hConvex : ∀ y, Convex ℝ {z | pref z y})
    (xstar : E) :
    Convex ℝ {x | pref x xstar ∧ ¬ pref xstar x} := by
  intro x hx y hy a b ha hb hab
  -- x ≻ xstar and y ≻ xstar
  obtain ⟨hx1, hx2⟩ := hx
  obtain ⟨hy1, hy2⟩ := hy
  constructor
  · -- Show a • x + b • y ≿ xstar
    -- By completeness, WLOG pref x y or pref y x
    rcases hComplete x y with hxy | hyx
    · -- Case: x ≿ y, so y is "worse". Upper contour set of y is convex and contains both x, y.
      -- Hence a • x + b • y ≿ y, and y ≿ xstar, so by transitivity done.
      have hmem_x : x ∈ {z | pref z y} := hxy
      have hmem_y : y ∈ {z | pref z y} := (hComplete y y).elim id id
      have hcomb : a • x + b • y ∈ {z | pref z y} :=
        hConvex y hmem_x hmem_y ha hb hab
      exact hTrans hcomb hy1
    · -- Case: y ≿ x. Upper contour set of x is convex and contains both.
      -- Hence a • x + b • y ≿ x, and x ≿ xstar.
      have hmem_x : x ∈ {z | pref z x} := (hComplete x x).elim id id
      have hmem_y : y ∈ {z | pref z x} := hyx
      have hcomb : a • x + b • y ∈ {z | pref z x} :=
        hConvex x hmem_x hmem_y ha hb hab
      exact hTrans hcomb hx1
  · -- Show ¬ pref xstar (a • x + b • y)
    intro hback
    -- If xstar ≿ combo, then by completeness and the above, we get xstar ≿ x or xstar ≿ y
    rcases hComplete x y with hxy | hyx
    · -- combo ≿ y (shown above), and xstar ≿ combo, so xstar ≿ y by transitivity
      have hmem_x : x ∈ {z | pref z y} := hxy
      have hmem_y : y ∈ {z | pref z y} := (hComplete y y).elim id id
      have hcomb : a • x + b • y ∈ {z | pref z y} :=
        hConvex y hmem_x hmem_y ha hb hab
      exact hy2 (hTrans hback hcomb)
    · have hmem_x : x ∈ {z | pref z x} := (hComplete x x).elim id id
      have hmem_y : y ∈ {z | pref z x} := hyx
      have hcomb : a • x + b • y ∈ {z | pref z x} :=
        hConvex x hmem_x hmem_y ha hb hab
      exact hx2 (hTrans hback hcomb)