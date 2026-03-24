import Mathlib

theorem external_direct_product_closed {S T : Type} [Mul S] [Mul T] (x y : S × T) :
    x * y ∈ (Set.univ : Set (S × T)) := by
  simp