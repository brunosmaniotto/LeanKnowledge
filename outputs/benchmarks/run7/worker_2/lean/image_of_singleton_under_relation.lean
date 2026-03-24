import Mathlib

open Set

variable {S T : Type} (R : Set (S × T)) (s : S)

theorem image_singleton :
    {t | (s, t) ∈ R} = {t | ∃ s' ∈ ({s} : Set S), (s', t) ∈ R} := by
  ext t
  simp [mem_singleton_iff]