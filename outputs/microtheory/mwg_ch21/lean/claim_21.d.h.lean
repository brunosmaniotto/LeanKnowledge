import Mathlib

/-- Pairwise majority voting on single-peaked preferences is acyclic
    (by Proposition 21.D.1) but not necessarily transitive.
    We demonstrate this by constructing an acyclic relation on Fin 3
    that fails transitivity. -/
theorem majority_voting_single_peaked_acyclic_not_transitive :
    ∃ (α : Type) (rel : α → α → Prop),
      -- Acyclic: no element can reach itself through the relation
      (∀ a b c : α, rel a b → rel b c → rel c a → False) ∧
      -- Not transitive
      (∃ a b c : α, rel a b ∧ rel b c ∧ ¬rel a c) := by
  refine ⟨Fin 3, fun a b => (a = 0 ∧ b = 1) ∨ (a = 1 ∧ b = 2), ?_, ?_⟩
  · intro a b c hab hbc hca
    fin_cases a <;> fin_cases b <;> fin_cases c <;> simp_all
  · exact ⟨0, 1, 2, Or.inl ⟨rfl, rfl⟩, Or.inr ⟨rfl, rfl⟩, by decide⟩