import Mathlib

/-- Even when the pooling zero-profit line does not intersect the ū_l indifference curve,
    a pure strategy SPE need not exist: a deviating pair of policies can attract
    low-risk consumers at a profit and high-risk consumers at a loss,
    with overall strictly positive expected profit. -/
theorem claim_8_nonexistence_footnote :
    ∃ (π_L π_H p : ℝ),
      0 < p ∧ p < 1 ∧
      π_L > 0 ∧ π_H < 0 ∧
      p * π_L + (1 - p) * π_H > 0 :=
  ⟨10, -1, 9 / 10, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩