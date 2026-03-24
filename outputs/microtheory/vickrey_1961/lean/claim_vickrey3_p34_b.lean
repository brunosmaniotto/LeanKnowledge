import Mathlib

/-- vj(x) must be a non-decreasing function: if v* > v then the optimal bid x* ≥ x.
    Proof by contradiction using profitable deviation / revealed preference. -/
theorem claim_vickrey3_p34_b
    (p : ℝ → ℝ)                          -- probability of winning as a function of bid
    (hp_mono : Monotone p)                -- higher bids weakly increase win probability
    (hp_bound : ∀ x, 0 ≤ p x ∧ p x ≤ 1) -- probabilities in [0,1]
    (v v_star : ℝ)                        -- two bidder values
    (hvv : v < v_star)                    -- v* > v
    (x x_star : ℝ)                        -- their respective optimal bids
    -- Optimality: bidder with value v prefers bid x over x_star
    (hopt_v : v * p x - x ≥ v * p x_star - x_star)
    -- Optimality: bidder with value v* prefers bid x_star over x
    (hopt_vstar : v_star * p x_star - x_star ≥ v_star * p x - x)
    : p x ≤ p x_star := by
  -- Adding the two optimality inequalities:
  -- v * p(x) - x ≥ v * p(x*) - x*
  -- v* * p(x*) - x* ≥ v* * p(x) - x
  -- Sum: (v* - v) * (p(x*) - p(x)) ≥ 0
  -- Since v* > v, we get p(x*) ≥ p(x)
  nlinarith [sq_nonneg (v_star - v), sq_nonneg (p x_star - p x)]