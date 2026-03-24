import Mathlib

/-- A separating equilibrium in the Rothschild–Stiglitz insurance market (MWG §8.1).
    High-risk gets full insurance ψ^c_h = (L, π_h·L); low-risk gets (B_l, p_l). -/
structure SeparatingEquilibrium where
  L : ℝ              -- loss amount
  π_h : ℝ            -- high-risk accident probability
  π_l : ℝ            -- low-risk accident probability
  B_l : ℝ            -- low-risk benefit (coverage)
  p_l : ℝ            -- low-risk premium
  u_h : ℝ → ℝ → ℝ   -- high-risk utility u_h(benefit, premium)
  u_l : ℝ → ℝ → ℝ   -- low-risk utility u_l(benefit, premium)
  ũ_l : ℝ            -- low-risk reservation utility level
  -- (i) Insurer non-negative profit on low-risk contract
  zero_profit_low : p_l ≥ π_l * B_l
  -- (ii) IC for high-risk: no incentive to mimic low-risk
  ic_high : u_h L (π_h * L) ≥ u_h B_l p_l
  -- (iii) IR for low-risk: contract at least as good as reservation
  ir_low : u_l B_l p_l ≥ ũ_l

/-- The low-risk contract in a separating equilibrium lies in the shaded region
    satisfying all three constraints simultaneously. -/
theorem shaded_region (eq : SeparatingEquilibrium) :
    (eq.p_l ≥ eq.π_l * eq.B_l) ∧
    (eq.u_h eq.L (eq.π_h * eq.L) ≥ eq.u_h eq.B_l eq.p_l) ∧
    (eq.u_l eq.B_l eq.p_l ≥ eq.ũ_l) :=
  ⟨eq.zero_profit_low, eq.ic_high, eq.ir_low⟩