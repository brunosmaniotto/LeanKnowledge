import Mathlib

/-- Claim 7.7(a): In matching pennies with interior mixing probabilities
    x, y ∈ (0,1), every information set is reached with positive probability,
    so Bayes' rule uniquely pins down beliefs:
      α₁ = x,  β₁ = x(1−y)/(x(1−y)+y(1−x)),  γ₁ = xy/(xy+(1−x)(1−y)).
    We verify the denominators are positive and each belief is in (0,1). -/
theorem Claim_7_7_a
    (x y : ℝ)
    (hx0 : 0 < x) (hx1 : x < 1)
    (hy0 : 0 < y) (hy1 : y < 1) :
    -- Every information set reached with positive probability
    0 < x * (1 - y) + y * (1 - x) ∧
    0 < x * y + (1 - x) * (1 - y) ∧
    -- β₁ = x(1−y)/(x(1−y) + y(1−x)) is a valid probability
    0 < x * (1 - y) / (x * (1 - y) + y * (1 - x)) ∧
    x * (1 - y) / (x * (1 - y) + y * (1 - x)) < 1 ∧
    -- γ₁ = xy/(xy + (1−x)(1−y)) is a valid probability
    0 < x * y / (x * y + (1 - x) * (1 - y)) ∧
    x * y / (x * y + (1 - x) * (1 - y)) < 1 := by
  have h1x : (0 : ℝ) < 1 - x := by linarith
  have h1y : (0 : ℝ) < 1 - y := by linarith
  have hn1 : (0 : ℝ) < x * (1 - y) := mul_pos hx0 h1y
  have hn2 : (0 : ℝ) < y * (1 - x) := mul_pos hy0 h1x
  have hn3 : (0 : ℝ) < x * y := mul_pos hx0 hy0
  have hn4 : (0 : ℝ) < (1 - x) * (1 - y) := mul_pos h1x h1y
  have hd1 : (0 : ℝ) < x * (1 - y) + y * (1 - x) := by linarith
  have hd2 : (0 : ℝ) < x * y + (1 - x) * (1 - y) := by linarith
  exact ⟨hd1, hd2, div_pos hn1 hd1, by rw [div_lt_one hd1]; linarith,
    div_pos hn3 hd2, by rw [div_lt_one hd2]; linarith⟩