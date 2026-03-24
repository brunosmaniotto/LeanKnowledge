import Mathlib

theorem exists_submonoid (M : Type u) [Monoid M] (T : Set M) 
    (h_one : (1 : M) ∈ T) (h_mul : ∀ a b, a ∈ T → b ∈ T → a * b ∈ T) :
    ∃ (S : Submonoid M), S.carrier = T := by
  refine ⟨
    { carrier := T
      one_mem' := h_one
      mul_mem' := fun ha hb => h_mul _ _ ha hb
    }, rfl⟩