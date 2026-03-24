import Mathlib

theorem reduced_residue_system_subset (m : ℕ) (h : 1 < m) :
    (∅ : Set (ZMod m)) ⊂ {x | IsUnit x} ∧ {x | IsUnit x} ⊂ (Set.univ : Set (ZMod m)) := by
  haveI : Fact (1 < m) := ⟨h⟩
  have h1 : IsUnit (1 : ZMod m) := isUnit_one
  have h0 : ¬ IsUnit (0 : ZMod m) := by simp
  have mem1 : (1 : ZMod m) ∈ {x | IsUnit x} := h1
  have h_empty : (∅ : Set (ZMod m)) ⊂ {x | IsUnit x} := by
    refine Set.empty_ssubset.mpr ⟨1, mem1⟩
  have h_univ : {x | IsUnit x} ⊂ (Set.univ : Set (ZMod m)) := by
    refine ⟨Set.subset_univ _, fun h => ?_⟩
    have h0' : (0 : ZMod m) ∈ {x | IsUnit x} := h (Set.mem_univ 0)
    simp at h0'
  exact ⟨h_empty, h_univ⟩