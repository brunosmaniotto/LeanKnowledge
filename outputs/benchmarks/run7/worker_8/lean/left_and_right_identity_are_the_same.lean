import Mathlib

theorem left_and_right_identity_eq_and_unique {S : Type} (circ : S → S → S) (e_L e_R : S)
    (h_left : ∀ x, circ e_L x = x) (h_right : ∀ x, circ x e_R = x) :
    e_L = e_R ∧ (∀ e_L', (∀ x, circ e_L' x = x) → e_L' = e_L) ∧ (∀ e_R', (∀ x, circ x e_R' = x) → e_R' = e_L) := by
  have h_eq : e_L = e_R := by
    calc
      e_L = circ e_L e_R := Eq.symm (h_right e_L)
      _ = e_R := h_left e_R
  have h_left_unique : ∀ e_L', (∀ x, circ e_L' x = x) → e_L' = e_L := by
    intro e_L' h_left'
    calc
      e_L' = circ e_L' e_R := Eq.symm (h_right e_L')
      _ = e_R := h_left' e_R
      _ = e_L := Eq.symm h_eq
  have h_right_unique : ∀ e_R', (∀ x, circ x e_R' = x) → e_R' = e_L := by
    intro e_R' h_right'
    calc
      e_R' = circ e_L e_R' := Eq.symm (h_left e_R')
      _ = e_L := h_right' e_L
  exact ⟨h_eq, h_left_unique, h_right_unique⟩