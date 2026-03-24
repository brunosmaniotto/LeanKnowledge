import Mathlib

/-- A moral hazard insurance policy (p, B₀, B₁, …, B_L).
    `premium` is the price paid to the insurer; `benefit l` is the
    payout when the observed accident loss is level `l`.
    Benefits are conditioned on observable loss, not on effort. -/
structure InsurancePolicy (L : ℕ) where
  premium : ℝ
  benefit : Fin (L + 1) → ℝ