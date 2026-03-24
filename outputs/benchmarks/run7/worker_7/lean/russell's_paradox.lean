import Mathlib

theorem russell_paradox (U : Type) (E : U → U → Prop)
    (comprehension : ∀ (p : U → Prop), ∃ (r : U), ∀ (x : U), E x r ↔ p x) : False := by
  let p : U → Prop := λ x => ¬ E x x
  rcases comprehension p with ⟨r, hr⟩
  have h : E r r ↔ ¬ E r r := hr r
  by_cases h' : E r r
  · have : ¬ E r r := h.mp h'
    exact this h'
  · have : E r r := h.mpr h'
    exact h' this