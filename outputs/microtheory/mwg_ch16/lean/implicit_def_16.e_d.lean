import Mathlib

open BigOperators Finset

noncomputable def representative_utility
    {ι : Type*} [Fintype ι] {E : Type*} [AddCommGroup E]
    (w : ι → ℝ) (u : ι → E → ℝ) (X : ι → Set E) (x_agg : E) : ℝ :=
  sSup { v : ℝ | ∃ (x : ι → E),
    (∀ i, x i ∈ X i) ∧
    ∑ i, x i = x_agg ∧
    v = ∑ i, w i * u i (x i) }