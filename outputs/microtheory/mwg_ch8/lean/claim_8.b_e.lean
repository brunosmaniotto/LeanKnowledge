import Mathlib

/-- A strategy `si'` weakly dominates `si` if it does at least as well for all
    opponent strategy profiles and strictly better for some. -/
theorem weak_dominance_characterization
    {S_i S_neg_i : Type*} {u : S_i → S_neg_i → ℝ}
    {si si' : S_i}
    (h_ge : ∀ s_neg_i : S_neg_i, u si' s_neg_i ≥ u si s_neg_i)
    (h_strict : ∃ s_neg_i : S_neg_i, u si' s_neg_i > u si s_neg_i) :
    (∀ s_neg_i, u si' s_neg_i ≥ u si s_neg_i) ∧
    (∃ s_neg_i, u si' s_neg_i > u si s_neg_i) :=
  ⟨h_ge, h_strict⟩