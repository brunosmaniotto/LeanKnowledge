import Mathlib

-- Sub-lemma: nonzero elements generate the whole ring
lemma nonzero_generates_top {R : Type*} [CommRing R] (h : ∀ I : Ideal R, I = ⊥ ∨ I = ⊤) (x : R) (hx : x ≠ 0) : Ideal.span {x} = ⊤ := by
  have h_span := h (Ideal.span {x})
  cases h_span with
  | inl h_bot => 
    have : x ∈ Ideal.span {x} := Ideal.mem_span_singleton_self x
    rw [h_bot] at this
    simp at this
    exact absurd this hx
  | inr h_top => exact h_top

-- Sub-lemma: if only two ideals exist, then every nonzero element is a unit