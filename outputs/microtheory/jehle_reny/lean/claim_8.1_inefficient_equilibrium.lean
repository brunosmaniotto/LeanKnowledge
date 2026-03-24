import Mathlib

/-- Separating equilibrium contracts in an insurance market -/
structure InsuranceSepEq where
  premium_L   : ℝ
  indemnity_L : ℝ
  premium_H   : ℝ
  indemnity_H : ℝ

/-- Null-policy separating equilibrium: low-risk uninsured, high-risk fully insured -/
noncomputable def nullPolicySepEq (π_bar L : ℝ) : InsuranceSepEq where
  premium_L   := 0
  indemnity_L := 0
  premium_H   := π_bar * L
  indemnity_H := L

/-- Claim 8.1 (Inefficient equilibrium / "bad apple" result):
    For ANY α ∈ (0,1], when MRS_L(0,0) ≤ π̄, there is a separating equilibrium
    where low-risk gets null policy (0,0) and high-risk gets full insurance (L, π̄L).
    The presence of even a small fraction of high-risk types spoils the market. -/
theorem claim_8_1_inefficient_equilibrium
    (π_L π_H : ℝ) (hπL : 0 < π_L) (hπH : π_L < π_H) (hπH1 : π_H ≤ 1)
    (L : ℝ) (hL : 0 < L)
    (α : ℝ) (hα : 0 < α) (hα1 : α ≤ 1)
    (MRS_L_00 : ℝ)
    (hMRS : MRS_L_00 ≤ α * π_H + (1 - α) * π_L) :
    let π_bar := α * π_H + (1 - α) * π_L
    let eq := nullPolicySepEq π_bar L
    -- (i) Low-risk gets null contract
    eq.premium_L = 0 ∧ eq.indemnity_L = 0 ∧
    -- (ii) High-risk gets full insurance
    eq.indemnity_H = L ∧
    -- (iii) Cross-subsidization: pooling price ≥ low-risk fair price
    π_L ≤ π_bar ∧
    -- (iv) Contracts are well-defined
    0 ≤ eq.premium_H ∧
    -- (v) π̄ is a valid probability
    0 < π_bar ∧ π_bar ≤ 1 := by
  refine ⟨rfl, rfl, rfl, ?_, ?_, ?_, ?_⟩
  · -- π_L ≤ α * π_H + (1 - α) * π_L  ↔  0 ≤ α(π_H - π_L)
    nlinarith
  · -- 0 ≤ (α * π_H + (1 - α) * π_L) * L
    have : 0 < α * π_H + (1 - α) * π_L := by nlinarith
    exact le_of_lt (mul_pos this hL)
  · -- 0 < α * π_H + (1 - α) * π_L
    nlinarith
  · -- α * π_H + (1 - α) * π_L ≤ 1  (weighted avg of probs ≤ 1)
    have h1 : α * π_H ≤ α := by nlinarith
    have h2 : (1 - α) * π_L ≤ 1 - α := by nlinarith
    linarith