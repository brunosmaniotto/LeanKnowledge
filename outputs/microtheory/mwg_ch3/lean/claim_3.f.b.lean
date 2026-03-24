import Mathlib

open Set
open Topology

theorem convex_eq_iInter_halfspaces
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (K : Set E) (hK : Convex ℝ K) (hKcl : IsClosed K) (hKne : K.Nonempty) :
    K = {x : E | ∀ (f : E →L[ℝ] ℝ) (c : ℝ), (∀ y ∈ K, f y ≤ c) → f x ≤ c} := by
  ext x
  constructor
  · intro hx f c hfc
    exact hfc x hx
  · intro hx
    by_contra hxK
    obtain ⟨f, s, hf, hs⟩ := geometric_hahn_banach_closed_point hK hKcl hxK
    have h1 : ∀ y ∈ K, f y ≤ s := fun y hy => le_of_lt (hf y hy)
    have h2 : f x ≤ s := hx f s h1
    linarith