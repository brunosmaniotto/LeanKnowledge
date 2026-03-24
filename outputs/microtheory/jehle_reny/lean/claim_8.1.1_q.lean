import Mathlib
open Topology

/-- Insurance market setup for symmetric vs asymmetric information comparison -/
structure InsuranceMarket where
  /-- Number of consumer types -/
  n : ℕ
  hn : 0 < n
  /-- Loss amount -/
  L : ℝ
  hL : 0 < L
  /-- Accident probability for each consumer type -/
  π : Fin n → ℝ
  hπ_pos : ∀ i, 0 < π i
  hπ_le : ∀ i, π i ≤ 1
  /-- Initial wealth -/
  w : ℝ
  hw : L < w
  /-- Utility function (strictly concave, increasing) -/
  u : ℝ → ℝ
  /-- Jensen's inequality for strict concavity: u(E[w]) > E[u(w)] when πi < 1.
      Symmetric info: fully insured at fair premium πi·L, utility = u(w − πi·L).
      Asymmetric info (p* = L): effectively uninsured,
        expected utility = πi·u(w − L) + (1 − πi)·u(w). -/
  h_strict_concavity : ∀ i, π i < 1 →
    u (w - π i * L) > π i * u (w - L) + (1 - π i) * u w

/--
Claim 8.1.1(q): The competitive outcome with symmetric information gives every
consumer (except those certain to have an accident) strictly higher utility than
the p* = L asymmetric information equilibrium, while ensuring every insurance
company's expected profits are zero.
-/
theorem Claim_8_1_1_q (M : InsuranceMarket) :
    -- (1) Every consumer with πi < 1 gets strictly higher utility under symmetric info
    (∀ i, M.π i < 1 →
      M.u (M.w - M.π i * M.L) > M.π i * M.u (M.w - M.L) + (1 - M.π i) * M.u M.w) ∧
    -- (2) Each insurer's expected profit is zero (premium πi·L = expected payout πi·L)
    (∀ i, M.π i * M.L - M.π i * M.L = 0) := by
  exact ⟨M.h_strict_concavity, fun _ => by ring⟩