import Mathlib

variable {R : Type} [CommRing R]

lemma frac_add_formula (a c : R) (b d : Rˣ) :
    a * (↑b⁻¹ : R) + c * (↑d⁻¹ : R) = (a * (↑d : R) + (↑b : R) * c) * (↑(b * d)⁻¹ : R) := by
  calc
    a * (↑b⁻¹ : R) + c * (↑d⁻¹ : R) = (a * ↑b⁻¹ + c * ↑d⁻¹) * 1 := by ring
    _ = (a * ↑b⁻¹ + c * ↑d⁻¹) * (↑(b * d) * ↑(b * d)⁻¹) := by rw [Units.mul_inv]
    _ = (a * ↑b⁻¹ + c * ↑d⁻¹) * ((↑b * ↑d) * ↑(b * d)⁻¹) := by rw [Units.val_mul]
    _ = (a * ↑b⁻¹ * ↑b * ↑d + c * ↑d⁻¹ * ↑b * ↑d) * ↑(b * d)⁻¹ := by ring
    _ = (a * (↑b⁻¹ * ↑b) * ↑d + c * ↑d⁻¹ * ↑b * ↑d) * ↑(b * d)⁻¹ := by ring
    _ = (a * 1 * ↑d + c * ↑d⁻¹ * ↑b * ↑d) * ↑(b * d)⁻¹ := by rw [Units.inv_mul]
    _ = (a * ↑d + c * ↑d⁻¹ * ↑b * ↑d) * ↑(b * d)⁻¹ := by ring
    _ = (a * ↑d + c * ↑b * (↑d⁻¹ * ↑d)) * ↑(b * d)⁻¹ := by ring
    _ = (a * ↑d + c * ↑b * 1) * ↑(b * d)⁻¹ := by rw [Units.inv_mul]
    _ = (a * ↑d + ↑b * c) * ↑(b * d)⁻¹ := by ring