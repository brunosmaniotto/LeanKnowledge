import Mathlib
open Topology

/-- Player 1's expected payoff in Matching Pennies when p (resp. q) is the probability
    of Heads for Player 1 (resp. Player 2). -/
noncomputable def EP1 (p q : ℝ) : ℝ := (2 * p - 1) * (2 * q - 1)

/-- The unique Nash equilibrium of matching pennies is both players
    choosing Heads with probability 1/2. -/
theorem matching_pennies_unique_NE :
    (∀ p, EP1 p (1/2) ≤ EP1 (1/2) (1/2)) ∧
    (∀ q, EP1 (1/2) q ≥ EP1 (1/2) (1/2)) ∧
    (∀ p q, (∀ p', EP1 p' q ≤ EP1 p q) →
            (∀ q', EP1 p q ≤ EP1 p q') → p = 1/2 ∧ q = 1/2) := by
  refine ⟨fun p => ?_, fun q => ?_, fun p q hp hq => ?_⟩
  · -- EP1 p (1/2) = 0 = EP1 (1/2) (1/2)
    have h1 : EP1 p (1/2) = 0 := by unfold EP1; ring
    have h2 : EP1 (1/2) (1/2) = 0 := by unfold EP1; ring
    linarith
  · -- EP1 (1/2) q = 0 = EP1 (1/2) (1/2)
    have h1 : EP1 (1/2) q = 0 := by unfold EP1; ring
    have h2 : EP1 (1/2) (1/2) = 0 := by unfold EP1; ring
    linarith
  · constructor
    · -- p = 1/2: from hq (P2 minimizes), EP1 is linear in q with slope 2(2p-1)
      have hge : 0 ≤ 2 * p - 1 := by
        have h := hq (q + 1)
        have hdiff : EP1 p (q + 1) - EP1 p q = 2 * (2 * p - 1) := by unfold EP1; ring
        linarith
      have hle : 2 * p - 1 ≤ 0 := by
        have h := hq (q - 1)
        have hdiff : EP1 p (q - 1) - EP1 p q = -(2 * (2 * p - 1)) := by unfold EP1; ring
        linarith
      linarith
    · -- q = 1/2: from hp (P1 maximizes), EP1 is linear in p with slope 2(2q-1)
      have hle : 2 * q - 1 ≤ 0 := by
        have h := hp (p + 1)
        have hdiff : EP1 (p + 1) q - EP1 p q = 2 * (2 * q - 1) := by unfold EP1; ring
        linarith
      have hge : 0 ≤ 2 * q - 1 := by
        have h := hp (p - 1)
        have hdiff : EP1 (p - 1) q - EP1 p q = -(2 * (2 * q - 1)) := by unfold EP1; ring
        linarith
      linarith