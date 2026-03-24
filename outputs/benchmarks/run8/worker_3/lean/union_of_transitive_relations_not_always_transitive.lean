import Mathlib
open Set

theorem union_of_transitive_not_necessarily_transitive :
    ∃ (α : Type) (r1 r2 : Set (α × α)), 
        (∀ x y z, (x, y) ∈ r1 → (y, z) ∈ r1 → (x, z) ∈ r1) ∧
        (∀ x y z, (x, y) ∈ r2 → (y, z) ∈ r2 → (x, z) ∈ r2) ∧
        ¬ (∀ x y z, (x, y) ∈ r1 ∪ r2 → (y, z) ∈ r1 ∪ r2 → (x, z) ∈ r1 ∪ r2) := by
  use Fin 4
  let r1 : Set (Fin 4 × Fin 4) := {(0,1), (1,2), (0,2)}
  let r2 : Set (Fin 4 × Fin 4) := {(1,2), (2,3), (1,3)}
  exact ⟨r1, r2, by decide, by decide, by decide⟩