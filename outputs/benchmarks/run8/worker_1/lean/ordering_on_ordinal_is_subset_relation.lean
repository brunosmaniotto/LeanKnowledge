import Mathlib
open Set

theorem lt_iff_Iio_strict_subset (x y : Ordinal) : x < y ↔ Set.Iio x ⊂ Set.Iio y := by
  constructor
  · intro hlt
    constructor
    · intro z hz
      exact lt_trans hz hlt
    · intro h'
      have hx : x ∈ Set.Iio y := hlt
      have not_mem : x ∉ Set.Iio x := lt_irrefl x
      exact not_mem (h' hx)
  · intro h
    rcases h with ⟨h_sub, h_not⟩
    by_cases hlt : x < y
    · exact hlt
    · have hle : y ≤ x := le_of_not_gt hlt
      by_cases heq : x = y
      · exfalso
        apply h_not
        intro z hz
        rw [heq]
        exact hz
      · have hlt' : y < x := lt_of_le_of_ne hle (Ne.symm heq)
        have h_mem : y ∈ Set.Iio x := hlt'
        have h_mem' : y ∈ Set.Iio y := h_sub h_mem
        exact absurd h_mem' (lt_irrefl y)