import Mathlib

class InverseSemigroup (S : Type u) [Semigroup S] where
  inv : S → S
  mul_inv_self : ∀ a : S, a * inv a * a = a
  inv_mul_self : ∀ a : S, inv a * a * inv a = inv a

instance (G : Type*) [Group G] : InverseSemigroup G where
  inv := Inv.inv
  mul_inv_self a := by
    calc
      a * a⁻¹ * a = (a * a⁻¹) * a := by rw [mul_assoc]
      _ = 1 * a := by rw [mul_inv_cancel]
      _ = a := by rw [one_mul]
  inv_mul_self a := by
    calc
      a⁻¹ * a * a⁻¹ = (a⁻¹ * a) * a⁻¹ := by rw [mul_assoc]
      _ = 1 * a⁻¹ := by rw [inv_mul_cancel]
      _ = a⁻¹ := by rw [one_mul]