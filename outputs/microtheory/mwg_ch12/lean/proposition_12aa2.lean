import Mathlib

open Real

/-- The Nash reversion sustainability condition: the one-period deviation gain
    must be at most δ/(1-δ) times the per-period punishment loss. -/
structure NashReversionCondition where
  /-- One-period deviation gain for each period -/
  gain : ℕ → ℝ
  /-- Per-period punishment loss for each period -/
  loss : ℕ → ℝ
  gain_nonneg : ∀ t, 0 ≤ gain t
  loss_nonneg : ∀ t, 0 ≤ loss t

/-- An outcome path is sustainable under Nash reversion at discount factor δ
    if for every period, gain(t) ≤ (δ/(1-δ)) * loss(t). -/
def sustainable (c : NashReversionCondition) (δ : ℝ) : Prop :=
  0 < δ ∧ δ < 1 ∧ ∀ t, c.gain t ≤ (δ / (1 - δ)) * c.loss t