import Mathlib

variable {G : Type*} [Group G] (H : Subgroup G)

theorem lagrange_theorem : Nat.card H ∣ Nat.card G ∧ 
  Nat.card G = H.index * Nat.card H := by
  constructor
  · -- First part: H.card divides G.card
    use H.index
    rw [← H.card_mul_index]
  · -- Second part: G.card = index * H.card  
    rw [← H.card_mul_index, mul_comm]