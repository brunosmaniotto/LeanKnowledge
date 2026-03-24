import Mathlib
open Topology

/-- If a social welfare function W : (Fin I → ℝ) → ℝ is invariant under common
    changes of origin (i.e., W(u + α·e) depends only on W(u) and α),
    then W(u) = W(u') implies W(u + α·e) = W(u' + α·e). -/
theorem social_welfare_parallel_indifference
    {I : Type*} [Fintype I]
    (W : (I → ℝ) → ℝ)
    (h_inv : ∀ (u u' : I → ℝ) (α : ℝ),
      W u = W u' → W (u + Function.const I α) = W (u' + Function.const I α))
    (u u' : I → ℝ) (α : ℝ)
    (h : W u = W u') :
    W (u + Function.const I α) = W (u' + Function.const I α) :=
  h_inv u u' α h