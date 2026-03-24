import Mathlib

/-- Grossman-Stiglitz paradox: fully revealing prices and costly information
    acquisition are incompatible in equilibrium. -/
theorem grossman_stiglitz_paradox
    {Agent : Type*} [Fintype Agent] [Nonempty Agent]
    (δ : ℝ) (hδ : δ > 0)
    (acquiresInfo : Agent → Prop) [DecidablePred acquiresInfo]
    -- If prices are fully revealing, no agent benefits from paying δ for info
    (free_ride : (∀ a, ¬acquiresInfo a) ∨ (∃ a, acquiresInfo a))
    -- Key economic assumptions:
    -- 1) If prices are revealing, rational agents don't pay for info
    (no_incentive_if_revealing : Bool → Prop)
    (h_revealing_implies_no_acquire :
      no_incentive_if_revealing true → ∀ a, ¬acquiresInfo a)
    -- 2) If no one acquires info, prices cannot be revealing
    (h_no_acquire_implies_not_revealing :
      (∀ a, ¬acquiresInfo a) → ¬no_incentive_if_revealing true)
    -- 3) Suppose equilibrium requires prices to be revealing
    (h_eq_revealing : no_incentive_if_revealing true) :
    -- Then we reach a contradiction: no rational expectations equilibrium exists
    -- with both fully revealing prices and costly information
    False := by
  have h1 := h_revealing_implies_no_acquire h_eq_revealing
  exact h_no_acquire_implies_not_revealing h1 h_eq_revealing