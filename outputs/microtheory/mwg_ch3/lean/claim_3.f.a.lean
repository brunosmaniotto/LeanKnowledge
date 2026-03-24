import Mathlib

open Set
open Topology
open FiniteDimensional

/-- A closed convex set in a locally convex space equals the intersection of all
    closed half-spaces containing it. We formalize this via Mathlib's
    `closure (convexHull ℝ K)` characterization: for any set K, the intersection
    of all closed half-spaces containing K equals the closed convex hull of K.
    When K is already closed and convex, this gives K back. -/
theorem closed_convex_halfspace_intersection
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [FiniteDimensional ℝ E]
    (K : Set E) (hK_closed : IsClosed K) (hK_convex : Convex ℝ K) (hK_ne : K.Nonempty) :
    K = ⋂ (f : E →L[ℝ] ℝ) (c : ℝ) (_ : K ⊆ {x | f x ≤ c}), {x | f x ≤ c} := by
  ext x
  simp only [mem_iInter, mem_setOf_eq]
  constructor
  · intro hx f c hKfc
    exact hKfc hx
  · intro hx
    by_contra hxK
    -- By the geometric Hahn–Banach / separating hyperplane theorem,
    -- there is a continuous linear functional strictly separating x from K
    have := geometric_hahn_banach_closed_point hK_convex hK_closed hxK
    obtain ⟨f, s, hfs, hfx⟩ := this
    have hKs : K ⊆ {y | f y ≤ s} := by
      intro y hy
      exact le_of_lt (hfs y hy)
    have := hx f s hKs
    linarith