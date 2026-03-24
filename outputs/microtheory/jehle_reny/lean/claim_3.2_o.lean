import Mathlib
open Topology

/-- A linearly homogeneous function (homogeneous of degree 1) that is
    superadditive is concave. This formalizes Claim 3.2(o) from MWG. -/
theorem claim_3_2_o {n : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (hom : ∀ (t : ℝ), 0 ≤ t → ∀ (x : Fin n → ℝ), f (t • x) = t * f x)
    (hsup : ∀ (x y : Fin n → ℝ), f (x + y) ≥ f x + f y) :
    ConcaveOn ℝ Set.univ f := by
  constructor
  · exact convex_univ
  · intro x _ y _ a b ha hb _
    have h1 : f (a • x + b • y) ≥ f (a • x) + f (b • y) := hsup _ _
    have h2 : f (a • x) = a * f x := hom a ha x
    have h3 : f (b • y) = b * f y := hom b hb y
    simp only [smul_eq_mul]
    linarith