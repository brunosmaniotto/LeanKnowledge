import Mathlib

theorem local_max_global_of_concave_and_local_min_global_of_convex :
    (∀ (f : ℝ → ℝ), ConcaveOn ℝ Set.univ f →
      ∀ x : ℝ, (∃ ε > 0, ∀ y, |y - x| < ε → f y ≤ f x) → ∀ y, f y ≤ f x) ∧
    (∀ (f : ℝ → ℝ), ConvexOn ℝ Set.univ f →
      ∀ x : ℝ, (∃ ε > 0, ∀ y, |y - x| < ε → f x ≤ f y) → ∀ y, f x ≤ f y) := by
  constructor
  · -- Concave: local max → global max
    intro f hf x ⟨ε, hε, hloc⟩ y
    by_contra hlt; push_neg at hlt
    set t := min (ε / (2 * (|y - x| + 1))) (1 / 2)
    have ht_pos : 0 < t := by positivity
    have ht_le : t ≤ 1 / 2 := min_le_right _ _
    have hdenom : (0 : ℝ) < 2 * (|y - x| + 1) := by positivity
    have ht_mul : t * (2 * (|y - x| + 1)) ≤ ε := by
      have h1 := min_le_left (ε / (2 * (|y - x| + 1))) (1 / 2)
      have h2 := mul_le_mul_of_nonneg_right h1 (le_of_lt hdenom)
      have h3 : ε / (2 * (|y - x| + 1)) * (2 * (|y - x| + 1)) = ε := by
        field_simp
      linarith
    have hclose : |(1 - t) * x + t * y - x| < ε := by
      have hsub : (1 - t) * x + t * y - x = t * (y - x) := by ring
      rw [hsub, abs_mul, abs_of_pos ht_pos]
      nlinarith [abs_nonneg (y - x)]
    have hconc : (1 - t) * f x + t * f y ≤ f ((1 - t) * x + t * y) :=
      hf.2 (Set.mem_univ x) (Set.mem_univ y) (by linarith) (le_of_lt ht_pos) (by ring)
    nlinarith [hloc ((1 - t) * x + t * y) hclose]
  · -- Convex: local min → global min
    intro f hf x ⟨ε, hε, hloc⟩ y
    by_contra hlt; push_neg at hlt
    set t := min (ε / (2 * (|y - x| + 1))) (1 / 2)
    have ht_pos : 0 < t := by positivity
    have ht_le : t ≤ 1 / 2 := min_le_right _ _
    have hdenom : (0 : ℝ) < 2 * (|y - x| + 1) := by positivity
    have ht_mul : t * (2 * (|y - x| + 1)) ≤ ε := by
      have h1 := min_le_left (ε / (2 * (|y - x| + 1))) (1 / 2)
      have h2 := mul_le_mul_of_nonneg_right h1 (le_of_lt hdenom)
      have h3 : ε / (2 * (|y - x| + 1)) * (2 * (|y - x| + 1)) = ε := by
        field_simp
      linarith
    have hclose : |(1 - t) * x + t * y - x| < ε := by
      have hsub : (1 - t) * x + t * y - x = t * (y - x) := by ring
      rw [hsub, abs_mul, abs_of_pos ht_pos]
      nlinarith [abs_nonneg (y - x)]
    have hconv : f ((1 - t) * x + t * y) ≤ (1 - t) * f x + t * f y :=
      hf.2 (Set.mem_univ x) (Set.mem_univ y) (by linarith) (le_of_lt ht_pos) (by ring)
    nlinarith [hloc ((1 - t) * x + t * y) hclose]