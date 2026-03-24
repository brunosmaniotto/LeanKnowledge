import Mathlib

variable (S : Type) [Mul S] (T : Type) [AddCommGroup T]

/-- The set of homomorphisms from a magma `S` to an additive commutative group `T` is an additive subgroup of the additive group of all functions from `S` to `T`. -/
def homSubgroup : AddSubgroup (S → T) where
  carrier := {f | ∀ x y, f (x * y) = f x + f y}
  zero_mem' := by
    intro x y
    simp
  add_mem' := by
    intro f g hf hg x y
    simp only [Set.mem_setOf_eq] at hf hg ⊢
    simp [Pi.add_apply]
    rw [hf, hg]
    abel
  neg_mem' := by
    intro f hf x y
    simp only [Set.mem_setOf_eq] at hf ⊢
    simp [Pi.neg_apply]
    rw [hf]
    exact neg_add (f x) (f y)