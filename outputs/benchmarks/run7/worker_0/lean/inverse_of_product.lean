import Mathlib

open Set
open scoped Pointwise

variable {G : Type} [Group G] (X Y : Set G)

theorem set_inv_mul : (X * Y)⁻¹ = Y⁻¹ * X⁻¹ := by
  ext g
  constructor
  · intro h
    rw [mem_inv, mem_mul] at h
    rcases h with ⟨x, hx, y, hy, hxy⟩
    rw [mem_mul]
    refine ⟨y⁻¹, ?_, x⁻¹, ?_, ?_⟩
    · rw [mem_inv, inv_inv]
      exact hy
    · rw [mem_inv, inv_inv]
      exact hx
    · calc
        y⁻¹ * x⁻¹ = (x * y)⁻¹ := by rw [mul_inv_rev]
        _ = g⁻¹⁻¹ := by rw [hxy]
        _ = g := inv_inv g
  · intro h
    rw [mem_mul] at h
    rcases h with ⟨a, ha, b, hb, hab⟩
    rw [mem_inv] at ha hb
    rw [mem_inv, mem_mul]
    refine ⟨b⁻¹, hb, a⁻¹, ha, ?_⟩
    calc
      b⁻¹ * a⁻¹ = (a * b)⁻¹ := by rw [mul_inv_rev]
      _ = g⁻¹ := by rw [hab]