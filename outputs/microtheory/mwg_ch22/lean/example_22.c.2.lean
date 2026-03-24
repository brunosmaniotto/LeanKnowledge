import Mathlib

noncomputable def maximin_SWF {I : Type*} [Fintype I] [Nonempty I]
    (β : I → ℝ) (u : I → ℝ) : ℝ :=
  Finset.inf' Finset.univ Finset.univ_nonempty (fun i => β i * u i)

/-- Symmetric maximin SWF: W(u) = Min{u₁, …, uᵢ} -/
noncomputable def maximin_SWF_symmetric {I : Type*} [Fintype I] [Nonempty I]
    (u : I → ℝ) : ℝ :=
  Finset.inf' Finset.univ Finset.univ_nonempty u