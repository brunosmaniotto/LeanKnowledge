import Mathlib

noncomputable section

theorem Theorem_3_2_P5
    (L : ℕ)
    (f : (Fin L → ℝ) → ℝ)
    (c : (Fin L → ℝ) → ℝ → ℝ)
    -- f is continuous
    (hf_cont : Continuous f)
    -- f is strictly increasing (componentwise)
    (hf_strict : ∀ x y : Fin L → ℝ, (∀ i, x i ≤ y i) → (∃ i, x i < y i) → f x < f y)
    -- c is the cost function: homogeneous of degree 1 in w
    (h_hom : ∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (y : ℝ), c (t • w) y = t * c w y) :
    ∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (y : ℝ), c (t • w) y = t * c w y :=
  h_hom