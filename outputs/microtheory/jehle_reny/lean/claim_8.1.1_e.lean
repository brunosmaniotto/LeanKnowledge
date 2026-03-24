import Mathlib

open Classical

/-- Under asymmetric information, equilibrium insurance prices must be uniform. -/
theorem claim_8_1_1_e
    (Consumer Firm : Type) [Fintype Consumer] [Fintype Firm] [Nonempty Firm]
    (price : Consumer → ℝ)
    (expected_profit : Consumer → Firm → ℝ)
    -- Firms cannot distinguish consumers: expected profit depends only on price
    (h_anon : ∀ (i j : Consumer) (f : Firm), price i = price j → expected_profit i f = expected_profit j f)
    -- Non-negative expected profits on each sale in equilibrium
    (h_nonneg : ∀ (i : Consumer) (f : Firm), 0 ≤ expected_profit i f)
    -- Higher price implies strictly higher expected profit per policy
    (h_profit_mono : ∀ (i j : Consumer) (f : Firm), price i > price j → expected_profit i f > expected_profit j f)
    -- Equilibrium condition: no firm wants to increase supply unboundedly
    (h_equil : ∀ (i : Consumer) (f : Firm), expected_profit i f > 0 → False) :
    ∀ i j : Consumer, price i = price j := by
  intro i j
  by_contra h_ne
  rcases ne_iff_lt_or_gt.mp h_ne with h_lt | h_gt
  · -- price i < price j, so expected_profit j f > expected_profit i f ≥ 0
    obtain ⟨f⟩ := ‹Nonempty Firm›
    have h1 := h_profit_mono j i f (by linarith)
    have h2 := h_nonneg i f
    exact h_equil j f (by linarith)
  · -- price i > price j, so expected_profit i f > expected_profit j f ≥ 0
    obtain ⟨f⟩ := ‹Nonempty Firm›
    have h1 := h_profit_mono i j f h_gt
    have h2 := h_nonneg j f
    exact h_equil i f (by linarith)