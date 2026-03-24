import Mathlib
open Topology

/-- If k < a²/4, the equilibrium exhibits precarious stability: the positive discriminant
yields two crossing points, and between them the equilibrium bid exceeds the player's
valuation (overbidding), which is the source of instability. -/
theorem claim_vickrey3_p35_j
    (a k : ℝ)
    (ha : a > 0)
    (hk : k > 0)
    (hk_bound : k < a ^ 2 / 4) :
    -- Positive discriminant: two distinct equilibrium crossings exist
    a ^ 2 - 4 * k > 0 ∧
    -- There exists a valuation where the equilibrium bid exceeds v (overbidding)
    ∃ v : ℝ, 0 < v ∧ v * v < a * v - k := by
  constructor
  · nlinarith
  · refine ⟨a / 2, by linarith, ?_⟩
    have h1 : a / 2 * (a / 2) = a ^ 2 / 4 := by ring
    have h2 : a * (a / 2) = a ^ 2 / 2 := by ring
    linarith