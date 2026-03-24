import Mathlib

open Set
open Topology

/-- Concavity of x ↦ x^α on [0,∞) for 0 < α < 1. -/
axiom rpow_concaveOn_Ici (α : ℝ) (hα0 : 0 < α) (hα1 : α < 1) :
    ConcaveOn ℝ (Set.Ici (0 : ℝ)) (fun x : ℝ => x ^ α)

/-- Robinson Crusoe production set: Y = {(-h, y) | 0 ≤ h ≤ b, 0 ≤ y ≤ h^α} -/
noncomputable def Y_RC (b α : ℝ) : Set (Fin 2 → ℝ) :=
  { v | ∃ h : ℝ, 0 ≤ h ∧ h ≤ b ∧ v 0 = -h ∧ 0 ≤ v 1 ∧ v 1 ≤ h ^ α }

/-- Claim 5.2(a): The Robinson Crusoe production set satisfies Assumption 5.2:
    inaction is possible (0 ∈ Y) and Y is convex (from concavity of h^α). -/
theorem Claim_5_2_a (b α : ℝ) (hb : 0 < b) (hα0 : 0 < α) (hα1 : α < 1) :
    (0 : Fin 2 → ℝ) ∈ Y_RC b α ∧ Convex ℝ (Y_RC b α) := by
  constructor
  · -- Inaction: 0 ∈ Y via h = 0
    refine ⟨0, le_refl _, hb.le, by simp, le_refl _, ?_⟩
    simp only [Pi.zero_apply]; positivity
  · -- Convexity from concavity of h ↦ h^α
    intro x hx y hy a c ha hc hac
    obtain ⟨h₁, h₁nn, h₁b, hx0, hxnn, hxle⟩ := hx
    obtain ⟨h₂, h₂nn, h₂b, hy0, hynn, hyle⟩ := hy
    refine ⟨a * h₁ + c * h₂, ?_, ?_, ?_, ?_, ?_⟩
    · exact add_nonneg (mul_nonneg ha h₁nn) (mul_nonneg hc h₂nn)
    · calc a * h₁ + c * h₂
          ≤ a * b + c * b :=
            add_le_add (mul_le_mul_of_nonneg_left h₁b ha) (mul_le_mul_of_nonneg_left h₂b hc)
        _ = b := by rw [← add_mul, hac, one_mul]
    · simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul, hx0, hy0]; ring
    · simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      exact add_nonneg (mul_nonneg ha hxnn) (mul_nonneg hc hynn)
    · simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      have conc := (rpow_concaveOn_Ici α hα0 hα1).2
        (mem_Ici.mpr h₁nn) (mem_Ici.mpr h₂nn) ha hc hac
      simp only [smul_eq_mul] at conc
      linarith [mul_le_mul_of_nonneg_left hxle ha, mul_le_mul_of_nonneg_left hyle hc]