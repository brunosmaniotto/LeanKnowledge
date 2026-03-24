import Mathlib

-- Sub-lemma: membership in inverse set
lemma mem_set_inv_iff {G : Type*} [Group G] (S : Set G) (g : G) : g ∈ S⁻¹ ↔ g⁻¹ ∈ S := by
  exact Set.mem_inv

-- Sub-lemma: one direction of the subset relation