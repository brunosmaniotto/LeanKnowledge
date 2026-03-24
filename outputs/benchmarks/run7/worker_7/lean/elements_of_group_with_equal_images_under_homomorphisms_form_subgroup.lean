import Mathlib

variable {G H : Type*} [Group G] [Group H]

/-- The subgroup of `G` where two homomorphisms `f` and `g` agree. -/
def equalizer_subgroup (f g : G →* H) : Subgroup G where
  carrier := {x | f x = g x}
  one_mem' := by simp
  mul_mem' {x y} hx hy := by
    simp only [Set.mem_setOf_eq] at hx hy ⊢
    rw [f.map_mul, g.map_mul, hx, hy]
  inv_mem' {x} hx := by
    simp only [Set.mem_setOf_eq] at hx ⊢
    rw [f.map_inv, g.map_inv, hx]