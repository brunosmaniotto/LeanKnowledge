import Mathlib

-- Sub-lemma 1: Forward extension exists
lemma extension_exists_forward {S T S' T' : Type*} [MulOneClass S] [MulOneClass T] [MulOneClass S'] [MulOneClass T'] 
  (φ : S →* T) (ι_S : S →* S') (ι_T : T →* T') (h_inj_S : Function.Injective ι_S) 
  (h_inj_T : Function.Injective ι_T) 
  (h_ext : ∀ (f : S →* T'), (∀ x, f x = ι_T (φ x)) → ∃! (g : S' →* T'), ∀ x, g (ι_S x) = f x) : 
  ∃ (φ' : S' →* T'), ∀ x, φ' (ι_S x) = ι_T (φ x) := by
  -- Apply h_ext to the composition ι_T ∘ φ
  have h : ∀ x, (ι_T.comp φ) x = ι_T (φ x) := fun x => rfl
  obtain ⟨φ', hφ', _⟩ := h_ext (ι_T.comp φ) h
  exact ⟨φ', hφ'⟩

-- Sub-lemma 2: Backward extension exists