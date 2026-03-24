import Mathlib

variable {α β : Type*}

theorem cartesian_product_inter (S1 S2 : Set α) (T1 T2 : Set β) :
    (S1 ∩ S2) ×ˢ (T1 ∩ T2) = (S1 ×ˢ T1) ∩ (S2 ×ˢ T2) := by
  ext ⟨x, y⟩
  simp only [Set.mem_inter_iff, Set.mem_prod]
  tauto