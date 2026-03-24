import Mathlib

open Set
open Topology

theorem convex_combination_is_segment (n : ℕ) (x₁ x₂ : Fin n → ℝ) :
    {z : Fin n → ℝ | ∃ t : ℝ, 0 ≤ t ∧ t ≤ 1 ∧ z = t • x₁ + (1 - t) • x₂} =
    segment ℝ x₁ x₂ := by
  ext z
  simp only [segment_eq_image]
  constructor
  · rintro ⟨t, ht0, ht1, rfl⟩
    exact ⟨1 - t, ⟨by linarith, by linarith⟩, by ext i; simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul]⟩
  · rintro ⟨t, ⟨ht0, ht1⟩, hz⟩
    exact ⟨1 - t, by linarith, by linarith, by rw [← hz]; ext i; simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul]⟩