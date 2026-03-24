import Mathlib

open Set

theorem claim_A1_4_4_c {S : Set ℝ} (hS : Convex ℝ S) (f : ℝ → ℝ) :
    ConvexOn ℝ S f ↔
      Convex ℝ {p : ℝ × ℝ | p.1 ∈ S ∧ f p.1 ≤ p.2} := by
  constructor
  · intro ⟨_, hf⟩
    intro p hp q hq a b ha hb hab
    simp only [mem_setOf_eq, Prod.fst_add, Prod.snd_add,
               Prod.smul_fst, Prod.smul_snd] at *
    constructor
    · exact hS hp.1 hq.1 ha hb hab
    · calc f (a * p.1 + b * q.1)
          ≤ a * f p.1 + b * f q.1 := hf hp.1 hq.1 ha hb hab
        _ ≤ a * p.2 + b * q.2 := by
            apply add_le_add
            · exact mul_le_mul_of_nonneg_left hp.2 ha
            · exact mul_le_mul_of_nonneg_left hq.2 hb
  · intro hconv
    constructor
    · exact hS
    · intro x hx y hy a b ha hb hab
      have hp : (⟨x, f x⟩ : ℝ × ℝ) ∈ {p : ℝ × ℝ | p.1 ∈ S ∧ f p.1 ≤ p.2} := by
        simp [hx]
      have hq : (⟨y, f y⟩ : ℝ × ℝ) ∈ {p : ℝ × ℝ | p.1 ∈ S ∧ f p.1 ≤ p.2} := by
        simp [hy]
      have := hconv hp hq ha hb hab
      simp only [mem_setOf_eq, Prod.fst_add, Prod.snd_add,
                 Prod.smul_fst, Prod.smul_snd] at this
      exact this.2