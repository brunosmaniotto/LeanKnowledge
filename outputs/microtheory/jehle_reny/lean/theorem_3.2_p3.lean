import Mathlib
open Topology

/-- MWG Theorem 3.2 (P3): If f is continuous and strictly increasing,
    c(w,y) = w · g(y) is strictly increasing and unbounded above in y for w > 0,
    where g = f⁻¹ is the input requirement function. -/
theorem Theorem_3_2_P3
    {f : ℝ → ℝ} (_hf_cont : Continuous f) (hf_mono : StrictMono f)
    {g : ℝ → ℝ} (hg_inv : ∀ y, f (g y) = y) :
    (∀ w : ℝ, 0 < w → StrictMono (fun y => w * g y)) ∧
    (∀ w : ℝ, 0 < w → ∀ M : ℝ, ∃ y : ℝ, M < w * g y) := by
  -- g is also a left inverse (since f is injective from strict monotonicity)
  have hg_left : ∀ x, g (f x) = x :=
    fun x => hf_mono.injective (hg_inv (f x))
  -- g inherits strict monotonicity from f
  have hg_mono : StrictMono g := by
    intro y₁ y₂ hy
    by_contra h
    push_neg at h
    have : y₂ ≤ y₁ :=
      calc y₂ = f (g y₂) := (hg_inv y₂).symm
        _ ≤ f (g y₁) := hf_mono.monotone h
        _ = y₁ := hg_inv y₁
    linarith
  -- g is unbounded: g(f(M+1)) = M+1 > M
  have hg_unbdd : ∀ M : ℝ, ∃ y, M < g y :=
    fun M => ⟨f (M + 1), by rw [hg_left]; linarith⟩
  constructor
  · -- Strict monotonicity: w > 0 and g strict mono ⟹ w * g strict mono
    intro w hw a b hab
    exact mul_lt_mul_of_pos_left (hg_mono hab) hw
  · -- Unboundedness: find y with g(y) > M/w, then w * g(y) > M
    intro w hw M
    obtain ⟨y, hy⟩ := hg_unbdd (M / w)
    exact ⟨y, by
      have h1 := mul_lt_mul_of_pos_left hy hw
      have h2 : w * (M / w) = M := by field_simp
      linarith⟩