import Mathlib

/-- The direct product of a finite family of K-vector spaces is itself a K-vector space. -/
theorem direct_product_is_vector_space (K : Type*) [Field K] (n : ℕ) (V : Fin n → Type*)
    [∀ i, AddCommGroup (V i)] [∀ i, Module K (V i)] :
    Nonempty (Module K (Π i : Fin n, V i)) :=
  ⟨inferInstance⟩