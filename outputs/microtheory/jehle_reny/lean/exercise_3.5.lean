import Mathlib
open Topology

/-- Exercise 3.5: For a homothetic function F = f ∘ g with f strictly increasing,
    g homogeneous of degree one with non-negative range, and F surjecting onto ℝ₊,
    f⁻¹(y) > 0 for all y > 0. -/
theorem exercise_3_5
    {N : ℕ} (g : (Fin N → ℝ) → ℝ) (f f_inv : ℝ → ℝ)
    (hf_strict : StrictMono f)
    (hg_hom : ∀ (t : ℝ), t > 0 → ∀ (x : Fin N → ℝ), g (t • x) = t * g x)
    (hg_nonneg : ∀ x, g x ≥ 0)
    (hf_inv_right : ∀ y, f (f_inv y) = y)
    (hF_surj : ∀ y ≥ (0 : ℝ), ∃ x, f (g x) = y)
    (y : ℝ) (hy : y > 0) : f_inv y > 0 := by
  -- g(0) = 0 from degree-1 homogeneity: g(2·0) = 2·g(0) and 2·0 = 0
  have hg0 : g 0 = 0 := by
    have h := hg_hom 2 (by norm_num) (0 : Fin N → ℝ)
    rw [smul_zero] at h; linarith
  -- f(0) ≤ 0: ∃ x with f(g(x)) = 0 and g(x) ≥ 0, so f(0) ≤ f(g(x)) = 0
  have hf0 : f 0 ≤ 0 := by
    obtain ⟨x, hx⟩ := hF_surj 0 (le_refl 0)
    calc f 0 ≤ f (g x) := hf_strict.monotone (hg_nonneg x)
         _ = 0 := hx
  -- If f_inv(y) ≤ 0 then y = f(f_inv(y)) ≤ f(0) ≤ 0, contradicting y > 0
  by_contra h; push_neg at h
  linarith [hf_strict.monotone h, hf_inv_right y]