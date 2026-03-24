import Mathlib

theorem identity_is_automorphism (S : Type u) [Mul S] :
    Function.Bijective (id : S → S) ∧ (∀ x y : S, id (x * y) = id x * id y) ∧ Set.range (id : S → S) = Set.univ := by
  refine ⟨Function.bijective_id, ?_, ?_⟩
  · intro x y
    rfl
  · simp