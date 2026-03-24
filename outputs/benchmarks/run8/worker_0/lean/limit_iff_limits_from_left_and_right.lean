import Mathlib
open Set Filter
open scoped Topology

variable {f : ℝ → ℝ} {c l : ℝ}

theorem limit_iff_left_right_limit :
    Tendsto f (𝓝[{c}ᶜ] c) (𝓝 l) ↔ Tendsto f (𝓝[<] c) (𝓝 l) ∧ Tendsto f (𝓝[>] c) (𝓝 l) := by
  constructor
  · intro h
    constructor
    · have h_left_incl : Iio c ⊆ {c}ᶜ := by
        intro x hx
        exact ne_of_lt hx
      exact h.mono_left (nhdsWithin_mono c h_left_incl)
    · have h_right_incl : Ioi c ⊆ {c}ᶜ := by
        intro x hx
        exact ne_of_gt hx
      exact h.mono_left (nhdsWithin_mono c h_right_incl)
  · intro ⟨h_left, h_right⟩
    have h_union : {c}ᶜ = Iio c ∪ Ioi c := by
      ext x
      constructor
      · intro hx
        have hx_ne : x ≠ c := hx
        rcases lt_or_gt_of_ne hx_ne with (h_lt | h_gt)
        · exact Or.inl h_lt
        · exact Or.inr h_gt
      · intro h
        rcases h with (h_lt | h_gt)
        · exact ne_of_lt h_lt
        · exact ne_of_gt h_gt
    rw [h_union, nhdsWithin_union]
    exact Tendsto.sup h_left h_right