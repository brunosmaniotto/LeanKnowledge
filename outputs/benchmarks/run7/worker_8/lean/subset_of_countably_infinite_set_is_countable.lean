import Mathlib

theorem subset_of_countably_infinite_is_countable {α : Type*} {S T : Set α} 
    (hT : T ⊆ S) (hS_count : Set.Countable S) (hS_inf : Set.Infinite S) : 
    Set.Countable T :=
  Set.Countable.mono hT hS_count