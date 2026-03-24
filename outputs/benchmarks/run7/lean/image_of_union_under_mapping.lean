import Mathlib

theorem image_of_union_eq_union_image {S T : Type*} (f : S → T) (A B : Set S) :
    f '' (A ∪ B) = f '' A ∪ f '' B :=
  Set.image_union f A B