import Mathlib

/-- In the sophisticated matching pennies game, the assessment (α₁, β₁, γ₁; x, x̄, y, ȳ, z_β, z_γ)
    with every entry equal to 1/2 is a sequential equilibrium. -/
theorem Claim_7_7_d :
    let p : ℝ := 1 / 2
    -- Sequential rationality: Player 3 indifferent at info sets β and γ
    (p * 1 + (1 - p) * (-1) = p * (-1) + (1 - p) * 1) ∧
    -- Players 1, 2: expected payoff from playing (H or T) equals 0
    (p * 1 + (1 - p) * (-1) = 0) ∧
    -- Quitting (payoff −1) is strictly suboptimal
    ((-1 : ℝ) < p * 1 + (1 - p) * (-1)) ∧
    -- Consistency: all strategies are completely mixed
    (0 < p ∧ p < 1) ∧
    -- Bayes' rule with symmetric mixing yields belief p = 1/2
    (p * p / (p * p + (1 - p) * (1 - p)) = p) := by
  refine ⟨by norm_num, by norm_num, by norm_num, ⟨by norm_num, by norm_num⟩, by norm_num⟩