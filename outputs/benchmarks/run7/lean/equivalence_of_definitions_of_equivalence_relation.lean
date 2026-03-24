import Mathlib

open Set

variable {α : Type*}

theorem equivalence_defs (R : Set (α × α)) :
    (∀ a, (a, a) ∈ R) ∧ (∀ a b, (a, b) ∈ R → (b, a) ∈ R) ∧ (∀ a b c, (a, b) ∈ R → (b, c) ∈ R → (a, c) ∈ R) ↔
    (diagonal α ∪ {p | (p.2, p.1) ∈ R} ∪ {p | ∃ x, (p.1, x) ∈ R ∧ (x, p.2) ∈ R}) ⊆ R := by
  constructor
  · intro h
    rcases h with ⟨h_refl, h_symm, h_trans⟩
    intro p hp
    rcases hp with (hp | hp)
    · rcases hp with (hp | hp)
      · obtain ⟨x, y⟩ := p
        have h_eq : x = y := Set.mem_diagonal_iff.1 hp
        subst y
        exact h_refl x
      · obtain ⟨x, y⟩ := p
        have h_inv : (y, x) ∈ R := hp
        exact h_symm y x h_inv
    · obtain ⟨x, y⟩ := p
      rcases hp with ⟨z, h_xz, h_zy⟩
      exact h_trans x z y h_xz h_zy
  · intro h
    have h_refl : ∀ a, (a, a) ∈ R := by
      intro a
      apply h
      left
      left
      exact Set.mem_diagonal a
    have h_symm : ∀ a b, (a, b) ∈ R → (b, a) ∈ R := by
      intro a b h_ab
      apply h
      left
      right
      exact h_ab
    have h_trans : ∀ a b c, (a, b) ∈ R → (b, c) ∈ R → (a, c) ∈ R := by
      intro a b c h_ab h_bc
      apply h
      right
      exact ⟨b, h_ab, h_bc⟩
    exact ⟨h_refl, h_symm, h_trans⟩