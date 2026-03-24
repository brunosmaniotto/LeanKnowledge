import Mathlib

variable {α : Type*} (R : Set (Set α)) (X : Set α)

structure IsAlgebra1 : Prop where
  hX : X ∈ R
  hsub : ∀ A ∈ R, A ⊆ X
  hcompl : ∀ A ∈ R, X \ A ∈ R
  hunion : ∀ A ∈ R, ∀ B ∈ R, A ∪ B ∈ R

structure IsAlgebra2 : Prop where
  hX : X ∈ R
  hsub : ∀ A ∈ R, A ⊆ X
  hunion : ∀ A ∈ R, ∀ B ∈ R, A ∪ B ∈ R
  hdiff : ∀ A ∈ R, ∀ B ∈ R, A \ B ∈ R

theorem isAlgebra1_iff_isAlgebra2 : IsAlgebra1 R X ↔ IsAlgebra2 R X := by
  constructor
  · intro h
    -- Prove closure under intersection
    have h_inter : ∀ A ∈ R, ∀ B ∈ R, A ∩ B ∈ R := by
      intro A hA B hB
      have hA_compl : X \ A ∈ R := h.hcompl A hA
      have hB_compl : X \ B ∈ R := h.hcompl B hB
      have h_union : (X \ A) ∪ (X \ B) ∈ R := h.hunion (X \ A) hA_compl (X \ B) hB_compl
      have h_eq : X \ ((X \ A) ∪ (X \ B)) = A ∩ B := by
        ext x
        constructor
        · intro hx
          have hxX : x ∈ X := hx.1
          have hx_union : x ∉ (X \ A) ∪ (X \ B) := hx.2
          have not_in_left : x ∉ X \ A := fun h => hx_union (Or.inl h)
          have not_in_right : x ∉ X \ B := fun h => hx_union (Or.inr h)
          have x_in_A : x ∈ A := by
            by_contra hxA
            exact not_in_left ⟨hxX, hxA⟩
          have x_in_B : x ∈ B := by
            by_contra hxB
            exact not_in_right ⟨hxX, hxB⟩
          exact ⟨x_in_A, x_in_B⟩
        · intro ⟨hxA, hxB⟩
          have hxX : x ∈ X := h.hsub A hA hxA
          refine ⟨hxX, ?_⟩
          intro h_union'
          rcases h_union' with (h' | h')
          · exact h'.2 hxA
          · exact h'.2 hxB
      rw [← h_eq]
      exact h.hcompl _ h_union
    -- Prove closure under set difference
    have h_diff : ∀ A ∈ R, ∀ B ∈ R, A \ B ∈ R := by
      intro A hA B hB
      have hB_compl : X \ B ∈ R := h.hcompl B hB
      have h_eq : A \ B = A ∩ (X \ B) := by
        ext x
        constructor
        · intro hx
          exact ⟨hx.1, h.hsub A hA hx.1, hx.2⟩
        · intro hx
          exact ⟨hx.1, hx.2.2⟩
      rw [h_eq]
      exact h_inter A hA (X \ B) hB_compl
    exact ⟨h.hX, h.hsub, h.hunion, h_diff⟩
  · intro h
    have hcompl : ∀ A ∈ R, X \ A ∈ R := by
      intro A hA
      exact h.hdiff X h.hX A hA
    exact ⟨h.hX, h.hsub, hcompl, h.hunion⟩