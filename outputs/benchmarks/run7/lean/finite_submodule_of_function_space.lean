import Mathlib

open Function Set

variable {R S G : Type*} [Ring R] [AddCommGroup G] [Module R G]

def finSupported : Submodule R (S → G) where
  carrier := {f | (support f).Finite}
  zero_mem' := by
    simp [support_zero]
  add_mem' {f g} hf hg := by
    have h_add : support (f + g) ⊆ support f ∪ support g := support_add f g
    have h_union : (support f ∪ support g).Finite := hf.union hg
    exact h_union.subset h_add
  smul_mem' r f hf := by
    have h_smul : support (r • f) ⊆ support f := by
      intro x hx
      simp only [mem_support, Pi.smul_apply] at hx ⊢
      intro h
      rw [h, smul_zero] at hx
      exact hx rfl
    exact hf.subset h_smul