import Mathlib

noncomputable section

variable {G H : Type*} [Group G] [Group H]
variable (N : Subgroup G) [N.Normal] (K : Subgroup H) [K.Normal]
variable (θ : G ⧸ N ≃* H ⧸ K)

def pullback : Subgroup (G × H) where
  carrier := {p | θ (QuotientGroup.mk p.1) = QuotientGroup.mk p.2}
  one_mem' := by
    simp [θ.map_one]
  mul_mem' := by
    rintro ⟨g, h⟩ ⟨g', h'⟩ hx hy
    simp only [Set.mem_setOf_eq] at hx hy ⊢
    simp [Prod.mk_mul_mk, QuotientGroup.mk_mul, θ.map_mul, hx, hy]
  inv_mem' := by
    rintro ⟨g, h⟩ hx
    simp only [Set.mem_setOf_eq] at hx ⊢
    simp [QuotientGroup.mk_inv, θ.map_inv, hx]