import Mathlib

open MeasureTheory Set

variable {L : ℕ}

axiom integral_of_neg_is_neg (f : ℝ → ℝ) (hf : ∀ t ∈ Icc (0 : ℝ) 1, f t < 0)
    (hc : Continuous f) : ∫ t in (0 : ℝ)..1, f t < 0

theorem gross_substitute_price_decrease
    (p_path : ℝ → Fin L → ℝ)
    (dp : ℝ → Fin L → ℝ)
    (h_dp_neg : ∀ t ∈ Icc (0 : ℝ) 1, ∀ ℓ : Fin L, dp t ℓ < 0)
    (h_ftc : ∀ ℓ : Fin L, p_path 1 ℓ - p_path 0 ℓ = ∫ t in (0 : ℝ)..1, dp t ℓ)
    (h_cont : ∀ ℓ : Fin L, Continuous (fun t => dp t ℓ)) :
    ∀ ℓ : Fin L, p_path 1 ℓ - p_path 0 ℓ < 0 := by
  intro ℓ
  rw [h_ftc ℓ]
  exact integral_of_neg_is_neg (fun t => dp t ℓ) (fun t ht => h_dp_neg t ht ℓ) (h_cont ℓ)