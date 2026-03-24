import Mathlib

open Function

theorem abelian_iff_abelian_of_mulEquiv {G H : Type _} [Group G] [Group H] (e : G ≃* H) :
    (∀ x y : G, x * y = y * x) ↔ (∀ x y : H, x * y = y * x) := by
  constructor
  · intro hG h1 h2
    apply e.symm.injective
    rw [e.symm.map_mul, e.symm.map_mul, hG]
  · intro hH g1 g2
    apply e.injective
    rw [e.map_mul, e.map_mul, hH]