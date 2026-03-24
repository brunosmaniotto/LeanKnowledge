import Mathlib
open Topology
open BigOperators

/-- When output is sold before uncertainty resolves (futures markets),
    profit is deterministic and all shareholders unanimously favor
    profit maximization. -/
theorem Claim_5G_d
    {n : ℕ}                          -- number of shareholders
    (θ : Fin n → ℝ)                  -- ownership shares
    (hθ_pos : ∀ i, 0 < θ i)         -- positive ownership
    (hθ_sum : ∑ i : Fin n, θ i = 1) -- shares sum to 1
    (p_futures : ℝ)                  -- futures price (known, deterministic)
    (hp : 0 < p_futures)
    (C : ℝ)                          -- cost of production (deterministic)
    (hC : 0 ≤ C)
    -- Profit is deterministic: π = p_futures * q - C for any output q
    -- Each shareholder i gets θ i * π
    -- All shareholders prefer maximizing π since θ i > 0
    : ∀ (q₁ q₂ : ℝ),
        p_futures * q₁ - C > p_futures * q₂ - C →
        ∀ i : Fin n, θ i * (p_futures * q₁ - C) > θ i * (p_futures * q₂ - C) := by
  intro q₁ q₂ hprofit i
  exact mul_lt_mul_of_pos_left hprofit (hθ_pos i)