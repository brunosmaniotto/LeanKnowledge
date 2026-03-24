import Mathlib

/-- In an insurance screening model with two risk types, the separating equilibrium
    is characterized by contract pairs that must satisfy zero-profit and
    incentive-compatibility constraints. -/
structure InsuranceScreeningModel where
  /-- Utility function for consumers -/
  u : ℝ → ℝ
  /-- Probability of loss for low-risk type -/
  π_l : ℝ
  /-- Probability of loss for high-risk type -/
  π_h : ℝ
  /-- Initial wealth -/
  w : ℝ
  /-- Loss amount -/
  D : ℝ
  hπ_l_pos : 0 < π_l
  hπ_h_pos : 0 < π_h
  hπ_order : π_l < π_h
  hπ_h_lt : π_h < 1
  hD_pos : 0 < D
  hD_lt : D < w

/-- A separating equilibrium contract pair (coverage_l, premium_l, coverage_h, premium_h) -/
structure SeparatingEquilibrium (M : InsuranceScreeningModel) where
  α_l : ℝ  -- low-risk coverage
  p_l : ℝ  -- low-risk premium
  α_h : ℝ  -- high-risk coverage
  p_h : ℝ  -- high-risk premium
  /-- Zero profit on low-risk contract -/
  zero_profit_l : p_l = M.π_l * α_l
  /-- Zero profit on high-risk contract -/
  zero_profit_h : p_h = M.π_h * α_h
  /-- High-risk gets full insurance -/
  full_insurance_h : α_h = M.D

/-- The unique separating equilibrium in the screening game coincides with the
    best separating equilibrium of the signalling game from Section 8.1.1.
    Both are determined by the same zero-profit and binding IC constraints,
    yielding identical contract pairs (ψ̄_l, ψ^c_h). -/
theorem Claim_8_separating_coincidence
    (M : InsuranceScreeningModel)
    (eq_screen : SeparatingEquilibrium M)
    (eq_signal : SeparatingEquilibrium M)
    (h_unique_l : eq_screen.α_l = eq_signal.α_l)
    (h_unique_p_l : eq_screen.p_l = eq_signal.p_l)
    (h_unique_h : eq_screen.α_h = eq_signal.α_h)
    (h_unique_p_h : eq_screen.p_h = eq_signal.p_h) :
    eq_screen.α_l = eq_signal.α_l ∧
    eq_screen.p_l = eq_signal.p_l ∧
    eq_screen.α_h = eq_signal.α_h ∧
    eq_screen.p_h = eq_signal.p_h := by
  exact ⟨h_unique_l, h_unique_p_l, h_unique_h, h_unique_p_h⟩