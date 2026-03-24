import Mathlib

variable {α : Type*} (S : Set α)

theorem diagonal_relation_equivalence :
    (∀ x ∈ S, (fun (x y : α) => x ∈ S ∧ y ∈ S ∧ x = y) x x) ∧
    (∀ x ∈ S, ∀ y ∈ S, (fun (x y : α) => x ∈ S ∧ y ∈ S ∧ x = y) x y →
                       (fun (x y : α) => x ∈ S ∧ y ∈ S ∧ x = y) y x) ∧
    (∀ x ∈ S, ∀ y ∈ S, ∀ z ∈ S,
        (fun (x y : α) => x ∈ S ∧ y ∈ S ∧ x = y) x y →
        (fun (x y : α) => x ∈ S ∧ y ∈ S ∧ x = y) y z →
        (fun (x y : α) => x ∈ S ∧ y ∈ S ∧ x = y) x z) := by
  refine ⟨?_, ?_, ?_⟩
  · intro x hx
    exact ⟨hx, hx, rfl⟩
  · intro x hx y hy h
    rcases h with ⟨hxS, hyS, hxy⟩
    exact ⟨hyS, hxS, hxy.symm⟩
  · intro x hx y hy z hz h1 h2
    rcases h1 with ⟨hxS, hyS, hxy⟩
    rcases h2 with ⟨hy'S, hzS, hyz⟩
    exact ⟨hxS, hzS, hxy.trans hyz⟩