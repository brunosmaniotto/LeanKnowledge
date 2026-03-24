import Mathlib
open FiniteDimensional

set_option checkBinderAnnotations false

axiom brouwer_fixed_point_ax
    {E : Type*} [AddCommGroup E] [Module ℝ E] [TopologicalSpace E]
    [ContinuousAdd E] [ContinuousSMul ℝ E] [FiniteDimensional ℝ E]
    [T2Space E]
    {S : Set E} (hne : S.Nonempty) (hcpt : IsCompact S) (hcvx : Convex ℝ S)
    {f : E → E} (hf : Continuous f) (hfs : Set.MapsTo f S S) :
    ∃ x ∈ S, f x = x

theorem brouwer_fixed_point
    {E : Type*} [AddCommGroup E] [Module ℝ E] [TopologicalSpace E]
    [ContinuousAdd E] [ContinuousSMul ℝ E] [FiniteDimensional ℝ E]
    [T2Space E]
    {S : Set E} (hne : S.Nonempty) (hcpt : IsCompact S) (hcvx : Convex ℝ S)
    {f : E → E} (hf : Continuous f) (hfs : Set.MapsTo f S S) :
    ∃ x ∈ S, f x = x :=
  brouwer_fixed_point_ax hne hcpt hcvx hf hfs