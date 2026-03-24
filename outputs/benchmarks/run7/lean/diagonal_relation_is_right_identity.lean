import Mathlib

variable {S T : Type _}

theorem diagonal_comp_right (R : Set (S × T)) :
    {p : S × T | ∃ (y : S), (p.1, y) ∈ Set.diagonal S ∧ (y, p.2) ∈ R} = R := by
  ext ⟨x, z⟩
  constructor
  · intro h
    rcases h with ⟨y, h_diag, hR⟩
    have : x = y := by simpa [Set.diagonal] using h_diag
    subst this
    exact hR
  · intro h
    refine ⟨x, ?_, h⟩
    simp [Set.diagonal]