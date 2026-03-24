import Mathlib

variable {S T : Type _} [Preorder S] [Preorder T]

noncomputable def order_embedding_iso_image (e : S ↪o T) : S ≃o Set.range e :=
  {
    toEquiv := Equiv.ofInjective e e.injective
    map_rel_iff' := by
      intro x y
      have : (Equiv.ofInjective e e.injective : S → Set.range e) = (fun x => ⟨e x, ⟨x, rfl⟩⟩) := rfl
      rw [this]
      simp [Subtype.mk_le_mk, e.map_rel_iff]
  }