import Mathlib

open Finset BigOperators Pointwise
open BigOperators

theorem average_production_set_nearly_convex
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (Y : Set E) (J : ℕ) (hJ : 0 < J)
    (x : E) (hx : x ∈ Y) :
    x ∈ (J : ℝ)⁻¹ • {z : E | ∃ (f : Fin J → E), (∀ i, f i ∈ Y) ∧ z = ∑ i, f i} := by
  rw [Set.mem_smul_set]
  refine ⟨∑ _i : Fin J, x, ?_, ?_⟩
  · exact ⟨fun _ => x, fun _ => hx, rfl⟩
  · simp only [Finset.sum_const, Finset.card_fin]
    have hJne : (J : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
    rw [show J • x = (J : ℝ) • x from by rw [← Nat.smul_one_eq_cast, smul_assoc, one_smul]]
    rw [smul_smul, inv_mul_cancel₀ hJne, one_smul]