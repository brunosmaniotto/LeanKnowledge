import Mathlib

variable (P : Type u)

def SymmetryGroupIsGroup (S_P : Set (Equiv.Perm P))
    (h_id : (1 : Equiv.Perm P) ∈ S_P)
    (h_mul : ∀ f g, f ∈ S_P → g ∈ S_P → f * g ∈ S_P)
    (h_inv : ∀ f, f ∈ S_P → f⁻¹ ∈ S_P) : Subgroup (Equiv.Perm P) :=
  { carrier := S_P
    one_mem' := h_id
    mul_mem' := fun ha hb => h_mul _ _ ha hb
    inv_mem' := fun ha => h_inv _ ha }