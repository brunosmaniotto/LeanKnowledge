import Mathlib

theorem square_eq_univ (G : Type) [AddCommGroup G] (IsSquare : G → Prop) (square : Set G)
    (mem_square : ∀ a : G, a ∈ square ↔ IsSquare a)
    (isSquare_neg_of_not_isSquare : ∀ x : G, IsSquare (-x)) :
    square = Set.univ := by
  ext a
  constructor
  · intro _; exact Set.mem_univ a
  · intro _
    rw [mem_square]
    have h : IsSquare (-(-a)) := isSquare_neg_of_not_isSquare (-a)
    rw [neg_neg] at h
    exact h