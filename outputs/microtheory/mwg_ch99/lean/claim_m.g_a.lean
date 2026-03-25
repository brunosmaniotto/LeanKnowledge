import Mathlib

open Set

theorem Claim_M_G_a {N : ℕ} {A : Set (Fin N → ℝ)} (hA : Convex ℝ A)
    (f : (Fin N → ℝ) → ℝ) (hf : ConcaveOn ℝ A f) :
    Convex ℝ {p : (Fin N → ℝ) × ℝ | p.2 ≤ f p.1 ∧ p.1 ∈ A} := by
  intro x hx y hy a b ha hb hab
  simp only [mem_setOf_eq] at *
  refine ⟨?_, ?_⟩
  · -- Goal: (a • x + b • y).2 ≤ f (a • x + b • y).1
    -- Simplify product smul/add components
    show a • x.2 + b • y.2 ≤ f (a • x.1 + b • y.1)
    calc a • x.2 + b • y.2
        ≤ a • f x.1 + b • f y.1 := by
          apply add_le_add
          · exact smul_le_smul_of_nonneg_left hx.1 ha
          · exact smul_le_smul_of_nonneg_left hy.1 hb
      _ ≤ f (a • x.1 + b • y.1) := hf.2 hx.2 hy.2 ha hb hab
  · -- Goal: (a • x + b • y).1 ∈ A
    show a • x.1 + b • y.1 ∈ A
    exact hA hx.2 hy.2 ha hb hab