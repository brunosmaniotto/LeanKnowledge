import Mathlib

/-- Long-run competitive equilibrium: with inverse demand p = 39 − 0.009q,
    profit π(p) = p² − 2p − 399, and supply y(p) = 2p − 2,
    the equilibrium has p̂ = 21, Ĵ = 50 firms, each producing 40 units. -/
theorem Example_4_2 :
    let p_hat : ℝ := 21
    let profit := fun p : ℝ => p ^ 2 - 2 * p - 399
    let supply := fun p : ℝ => 2 * p - 2
    let demand := fun p : ℝ => (39 - p) / (9 / 1000)
    let J_hat : ℝ := 50
    -- Zero-profit condition: p² − 2p − 399 = 0
    profit p_hat = 0 ∧
    -- Market clearing: demand(p̂) = Ĵ · supply(p̂)
    demand p_hat = J_hat * supply p_hat ∧
    -- Individual firm output: y_j(p̂) = 40
    supply p_hat = 40 := by
  refine ⟨by norm_num, by norm_num, by norm_num⟩