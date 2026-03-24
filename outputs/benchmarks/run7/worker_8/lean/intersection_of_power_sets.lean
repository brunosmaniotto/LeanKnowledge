import Mathlib

open Set

theorem powerset_inter_eq (S T : Set α) : 𝒫 S ∩ 𝒫 T = 𝒫 (S ∩ T) := by
  ext x
  simp only [mem_inter_iff, mem_powerset_iff, subset_inter_iff]