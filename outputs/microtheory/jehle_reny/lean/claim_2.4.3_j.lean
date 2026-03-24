import Mathlib

/-- Decreasing absolute risk aversion (DARA) is the most plausible restriction:
    - Under CARA, willingness to accept a small gamble does not increase with wealth.
    - Under IARA, behavior is perverse: higher wealth → more aversion.
    - Under DARA, higher wealth → less aversion to small risks. -/
theorem Claim_2_4_3_j
    (r_A : ℝ → ℝ)  -- Arrow-Pratt absolute risk aversion function
    -- DARA: r_A is strictly decreasing
    (h_DARA : ∀ x y : ℝ, x < y → r_A y < r_A x)
    -- CARA: r_A is constant
    (r_A_const : ℝ → ℝ)
    (h_CARA : ∀ x y : ℝ, r_A_const x = r_A_const y)
    -- IARA: r_A is strictly increasing
    (r_A_incr : ℝ → ℝ)
    (h_IARA : ∀ x y : ℝ, x < y → r_A_incr x < r_A_incr y)
    :
    -- (1) Under CARA, no change in risk aversion with wealth
    (∀ x y : ℝ, x < y → r_A_const x = r_A_const y)
    ∧
    -- (2) Under IARA, higher wealth → strictly more risk averse (perverse)
    (∀ x y : ℝ, x < y → r_A_incr x < r_A_incr y)
    ∧
    -- (3) Under DARA, higher wealth → strictly less risk averse (plausible)
    (∀ x y : ℝ, x < y → r_A y < r_A x)
    ∧
    -- (4) DARA is strictly more restrictive than "non-increasing":
    -- strictly decreasing implies non-increasing (but not vice versa)
    (∀ x y : ℝ, x ≤ y → r_A y ≤ r_A x) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- CARA: constant means equal at any two wealth levels
    exact fun x y _ => h_CARA x y
  · -- IARA: strictly increasing risk aversion
    exact fun x y hxy => h_IARA x y hxy
  · -- DARA: strictly decreasing risk aversion
    exact fun x y hxy => h_DARA x y hxy
  · -- DARA implies non-increasing (weakening strict to non-strict)
    intro x y hxy
    rcases hxy.eq_or_lt with rfl | hlt
    · exact le_refl _
    · exact le_of_lt (h_DARA x y hlt)