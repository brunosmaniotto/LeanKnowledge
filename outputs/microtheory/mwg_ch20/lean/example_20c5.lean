import Mathlib

theorem Example_20C5 :
    let Y : Set (ℝ × ℝ) := {p | ∃ k : ℝ, 0 ≤ k ∧ p.1 = -k ∧ p.2 ≤ k}
    let y : ℕ → ℝ × ℝ := fun _ => (-1, 1)
    let y' : ℕ → ℝ × ℝ := fun _ => (0, 0)
    let p : ℕ → ℝ := fun _ => 1
    -- All y_t are in Y (with k=1)
    (∀ t, y t ∈ Y) ∧
    -- All y'_t are in Y (with k=0)
    (∀ t, y' t ∈ Y) ∧
    -- y is not efficient: y' weakly dominates y (both feasible, y' gives net 0 everywhere,
    -- but y gives net input -1 at t=0, so y' strictly dominates in first component at t=0)
    ((y' 0).1 > (y 0).1) ∧
    -- For all t ≥ 1, net outputs are the same (both 0)
    (∀ t, (y t).1 + (y t).2 = 0) ∧
    (∀ t, (y' t).1 + (y' t).2 = 0) ∧
    -- Myopic profit maximization: for price p=1, profit of y_t = 0 ≥ profit of any z ∈ Y
    (∀ t, ∀ z ∈ Y, p t * z.1 + p t * z.2 ≤ p t * (y t).1 + p t * (y t).2) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro t
    exact ⟨1, by norm_num, by norm_num, by norm_num⟩
  · intro t
    exact ⟨0, le_refl 0, by norm_num, le_refl 0⟩
  · norm_num
  · intro t; norm_num
  · intro t; norm_num
  · intro t z ⟨k, hk_pos, hz1, hz2⟩
    simp only [one_mul]
    rw [hz1]
    linarith