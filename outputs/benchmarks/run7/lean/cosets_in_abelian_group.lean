import Mathlib

theorem leftCoset_eq_rightCoset_in_abelian_group {G : Type*} [CommGroup G] (H : Subgroup G) (x : G) :
    QuotientGroup.leftRel H x = QuotientGroup.rightRel H x := by
  ext y
  simp only [QuotientGroup.leftRel_apply, QuotientGroup.rightRel_apply]
  constructor
  · intro h
    rw [← mul_comm] at h
    exact h
  · intro h
    rw [mul_comm] at h
    exact h