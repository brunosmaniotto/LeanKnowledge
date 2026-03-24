import Mathlib
open Topology

theorem concave_iff_neg_convex {𝕜 : Type*} [Semiring 𝕜] [PartialOrder 𝕜]
    {E : Type*} [AddCommMonoid E] [SMul 𝕜 E]
    {β : Type*} [AddCommGroup β] [PartialOrder β] [IsOrderedAddMonoid β] [Module 𝕜 β]
    {s : Set E} {f : E → β} :
    ConcaveOn 𝕜 s f ↔ ConvexOn 𝕜 s (-f) :=
  ⟨ConcaveOn.neg, fun h => by simpa using h.neg⟩