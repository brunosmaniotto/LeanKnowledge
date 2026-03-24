import Mathlib

open BigOperators
open Finset

variable {n : ℕ} {G : Type _} [Group G] {H : Fin n → Subgroup G}

/-- The canonical multiplication map from the product of a family of subgroups to the group. 
    We define it as the product of the list formed by the elements in the order of `Fin n`. -/
def φ : ((i : Fin n) → H i) → G := fun f => (List.ofFn (fun i => (f i : G))).prod