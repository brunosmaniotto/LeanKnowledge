import Mathlib

theorem set_diff_eq_self_iff_inter_eq_empty (S T : Set α) : S \ T = S ↔ S ∩ T = ∅ := by
  constructor
  · intro h
    ext x
    constructor
    · intro hx
      exfalso
      have hxS : x ∈ S := hx.1
      have hxT : x ∈ T := hx.2
      rw [← h] at hxS
      exact hxS.2 hxT
    · intro h
      exfalso
      simp at h
  · intro h
    ext x
    constructor
    · intro hx
      exact hx.1
    · intro hx
      constructor
      · exact hx
      · intro hxT
        have : x ∈ S ∩ T := ⟨hx, hxT⟩
        rw [h] at this
        simp at this