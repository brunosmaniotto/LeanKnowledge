import Mathlib

def kernel_is_subring {R₁ R₂ : Type} [Ring R₁] [Ring R₂] (φ : R₁ →+* R₂) : NonUnitalSubring R₁ :=
  { carrier := {x | φ x = 0}
    zero_mem' := by simp
    add_mem' := by
      intro a b ha hb
      simp only [Set.mem_setOf_eq] at ha hb ⊢
      simp [ha, hb, φ.map_add]
    neg_mem' := by
      intro a ha
      simp only [Set.mem_setOf_eq] at ha ⊢
      simp [ha, φ.map_neg]
    mul_mem' := by
      intro a b ha hb
      simp only [Set.mem_setOf_eq] at ha hb ⊢
      simp [ha, hb, φ.map_mul] }