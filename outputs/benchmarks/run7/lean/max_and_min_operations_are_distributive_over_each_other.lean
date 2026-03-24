import Mathlib

variable {α : Type*} [LinearOrder α]

theorem max_min_distributive (x y z : α) :
    max x (min y z) = min (max x y) (max x z) ∧
    max (min x y) z = min (max x z) (max y z) ∧
    min x (max y z) = max (min x y) (min x z) ∧
    min (max x y) z = max (min x z) (min y z) := by
  exact ⟨max_min_distrib_left x y z, max_min_distrib_right x y z,
         min_max_distrib_left x y z, min_max_distrib_right x y z⟩