import Mathlib

theorem Inverse_Element_is_Power_of_Order_Less_1 {G : Type*} [Group G] (g : G) (n : ℕ) (h_order : orderOf g = n) :
    g ^ ((n : ℤ) - 1) = g⁻¹ := by
  calc
    g ^ ((n : ℤ) - 1) = g ^ (n : ℤ) * g⁻¹ := by rw [zpow_sub_one]
    _ = (g ^ n) * g⁻¹ := by rw [zpow_natCast]
    _ = (g ^ orderOf g) * g⁻¹ := by rw [h_order]
    _ = 1 * g⁻¹ := by rw [pow_orderOf_eq_one]
    _ = g⁻¹ := by rw [one_mul]