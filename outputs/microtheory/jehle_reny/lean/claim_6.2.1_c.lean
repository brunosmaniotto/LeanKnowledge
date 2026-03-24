import Mathlib
open Topology

theorem order_invariance_swf
    {X : Type*} {I : Type*}
    (u : I → X → ℝ)
    (ψ : I → ℝ → ℝ)
    (hψ : ∀ i, StrictMono (ψ i))
    (f : (I → ℝ) → ℝ)
    (hf_ord : ∀ a b c d : I → ℝ, (∀ i, a i ≥ b i ↔ c i ≥ d i) → (f a ≥ f b ↔ f c ≥ f d))
    (x y : X) :
    f (fun i => ψ i (u i x)) ≥ f (fun i => ψ i (u i y)) ↔
    f (fun i => u i x) ≥ f (fun i => u i y) := by
  apply hf_ord
  intro i
  constructor
  · intro h
    by_contra h'
    push_neg at h'
    exact absurd h (not_le.mpr ((hψ i) h'))
  · exact fun h => (hψ i).monotone h