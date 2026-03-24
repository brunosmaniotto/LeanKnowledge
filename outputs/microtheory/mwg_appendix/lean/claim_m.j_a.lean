import Mathlib

open MeasureTheory Filter Topology

/-- The function f(x₁, x₂) = x₁² - x₂² has gradient zero at the origin,
    so the origin is a critical point, but it is neither a local maximizer
    nor a local minimizer (it is a saddle point). -/
theorem saddle_point_example :
    let f : ℝ × ℝ → ℝ := fun p => p.1 ^ 2 - p.2 ^ 2
    -- f(0,0) = 0
    f (0, 0) = 0 ∧
    -- Not a local maximizer: for any ε > 0, there exists a point within ε with f > 0
    (∀ ε > 0, ∃ p : ℝ × ℝ, dist p (0, 0) < ε ∧ f p > f (0, 0)) ∧
    -- Not a local minimizer: for any ε > 0, there exists a point within ε with f < 0
    (∀ ε > 0, ∃ p : ℝ × ℝ, dist p (0, 0) < ε ∧ f p < f (0, 0)) := by
  refine ⟨by norm_num, ?_, ?_⟩
  · intro ε hε
    refine ⟨(ε / 2, 0), ?_, ?_⟩
    · simp [dist_comm, Prod.dist_eq, Real.dist_eq, abs_of_pos (by linarith : ε / 2 > 0)]
      linarith
    · simp
      positivity
  · intro ε hε
    refine ⟨(0, ε / 2), ?_, ?_⟩
    · simp [dist_comm, Prod.dist_eq, Real.dist_eq, abs_of_pos (by linarith : ε / 2 > 0)]
      linarith
    · simp
      linarith [sq_nonneg (ε / 2), sq_pos_of_pos (by linarith : ε / 2 > 0)]