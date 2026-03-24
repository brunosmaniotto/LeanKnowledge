import Mathlib.Algebra.Group.Basic

variable {G : Type} [Semigroup G] [One G] [Inv G]

theorem left_id_is_right_id (h_left_id : ∀ a : G, 1 * a = a) (h_left_inv : ∀ a : G, a⁻¹ * a = 1) 
    (a : G) : a * 1 = a := by
  calc
    a * 1 = 1 * (a * 1) := by rw [h_left_id]
    _ = ((a⁻¹)⁻¹ * a⁻¹) * (a * 1) := by rw [← h_left_inv a⁻¹]
    _ = (a⁻¹)⁻¹ * (a⁻¹ * (a * 1)) := by rw [mul_assoc]
    _ = (a⁻¹)⁻¹ * ((a⁻¹ * a) * 1) := by rw [mul_assoc]
    _ = (a⁻¹)⁻¹ * (1 * 1) := by rw [h_left_inv a]
    _ = (a⁻¹)⁻¹ * 1 := by rw [h_left_id]
    _ = (a⁻¹)⁻¹ * (a⁻¹ * a) := by rw [h_left_inv a]
    _ = ((a⁻¹)⁻¹ * a⁻¹) * a := by rw [mul_assoc]
    _ = 1 * a := by rw [h_left_inv a⁻¹]
    _ = a := by rw [h_left_id]