import Mathlib

variable {R : Type} [CommRing R] {a b : R} {c d : Rˣ}

theorem units_div_eq_iff_mul_eq : a * (↑c⁻¹ : R) = b * (↑d⁻¹ : R) ↔ a * (d : R) = b * (c : R) := by
  constructor
  · intro h
    calc
      a * (d : R) = a * (d : R) * 1 := by simp
      _ = a * (d : R) * ((↑c⁻¹ : R) * (c : R)) := by simp [c.inv_mul]
      _ = a * (↑c⁻¹ : R) * (c : R) * (d : R) := by ring
      _ = (a * (↑c⁻¹ : R)) * ((c : R) * (d : R)) := by ring
      _ = (b * (↑d⁻¹ : R)) * ((c : R) * (d : R)) := by rw [h]
      _ = b * (↑d⁻¹ : R) * (c : R) * (d : R) := by ring
      _ = b * (c : R) * ((↑d⁻¹ : R) * (d : R)) := by ring
      _ = b * (c : R) * 1 := by simp [d.inv_mul]
      _ = b * (c : R) := by simp
  · intro h
    calc
      a * (↑c⁻¹ : R) = a * (↑c⁻¹ : R) * 1 := by simp
      _ = a * (↑c⁻¹ : R) * ((d : R) * (↑d⁻¹ : R)) := by simp [d.mul_inv]
      _ = a * (d : R) * (↑c⁻¹ : R) * (↑d⁻¹ : R) := by ring
      _ = (a * (d : R)) * (↑c⁻¹ : R) * (↑d⁻¹ : R) := by ring
      _ = (b * (c : R)) * (↑c⁻¹ : R) * (↑d⁻¹ : R) := by rw [h]
      _ = b * (c : R) * (↑c⁻¹ : R) * (↑d⁻¹ : R) := by ring
      _ = b * ((c : R) * (↑c⁻¹ : R)) * (↑d⁻¹ : R) := by ring
      _ = b * 1 * (↑d⁻¹ : R) := by simp [c.mul_inv]
      _ = b * (↑d⁻¹ : R) := by simp