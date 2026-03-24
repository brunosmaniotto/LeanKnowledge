import Mathlib

structure IsRingOfSets {α : Type*} (C : Set (Set α)) : Prop where
  empty_mem : ∅ ∈ C
  union_mem : ∀ s t, s ∈ C → t ∈ C → (s ∪ t) ∈ C
  diff_mem : ∀ s t, s ∈ C → t ∈ C → (s \ t) ∈ C

theorem intersection_of_rings_of_sets {α : Type*} {ι : Type*} {R : ι → Set (Set α)}
    (h : ∀ i, IsRingOfSets (R i)) : IsRingOfSets (⋂ i, R i) := by
  refine ⟨?_, ?_, ?_⟩
  · -- empty_mem
    simp [Set.mem_iInter]
    intro i
    exact (h i).empty_mem
  · -- union_mem
    intro s t hs ht
    simp [Set.mem_iInter] at hs ht ⊢
    intro i
    exact (h i).union_mem s t (hs i) (ht i)
  · -- diff_mem
    intro s t hs ht
    simp [Set.mem_iInter] at hs ht ⊢
    intro i
    exact (h i).diff_mem s t (hs i) (ht i)