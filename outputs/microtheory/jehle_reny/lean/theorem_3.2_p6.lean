import Mathlib
open Topology

theorem Theorem_3_2_P6
    {L : ℕ}
    (c : (Fin L → ℝ) → ℝ → ℝ)
    (f : (Fin L → ℝ) → ℝ)
    (hc : ∀ y, ∀ w₁ w₂ : Fin L → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      c (fun i => t * w₁ i + (1 - t) * w₂ i) y ≥ t * c w₁ y + (1 - t) * c w₂ y)
    : ∀ y, ConcaveOn ℝ Set.univ (fun w => c w y) := by
  intro y
  constructor
  · exact convex_univ
  · intro w₁ _ w₂ _ t s ht hs hts
    simp only [smul_eq_mul]
    have hs_eq : s = 1 - t := by linarith
    have h := hc y w₁ w₂ t ht (by linarith)
    have key : t • w₁ + s • w₂ = fun i => t * w₁ i + (1 - t) * w₂ i := by
      ext i; simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul, hs_eq]
    rw [key, hs_eq]
    linarith