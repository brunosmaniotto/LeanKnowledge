import Mathlib
open Set

theorem intermediate_value_theorem {f : ℝ → ℝ} {I : Set ℝ} (hI : Set.OrdConnected I)
    (hf : ContinuousOn f I) {a b k : ℝ} (ha : a ∈ I) (hb : b ∈ I) (hab : a < b)
    (hk : k ∈ Ioo (f a) (f b) ∨ k ∈ Ioo (f b) (f a)) : ∃ c ∈ Ioo a b, f c = k := by
  have hcc : Icc a b ⊆ I := hI.out ha hb
  have hf_cont_on : ContinuousOn f (Icc a b) := hf.mono hcc
  have hab' : a ≤ b := le_of_lt hab
  cases' hk with hk hk
  · exact intermediate_value_Ioo hab' hf_cont_on hk
  · exact intermediate_value_Ioo' hab' hf_cont_on hk