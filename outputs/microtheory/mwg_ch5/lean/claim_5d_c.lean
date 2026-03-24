import Mathlib

open Real

/-- A firm with nonsunk fixed setup cost K and convex variable cost C_v(q) with C_v(0)=0:
    total cost is C(0)=0 and C(q)=C_v(q)+K for q>0. The firm produces positive output
    only if profit covers both variable costs and the fixed cost K. -/
theorem Claim_5D_c
    (C_v : ℝ → ℝ)            -- variable cost function
    (K : ℝ)                   -- fixed setup cost
    (C : ℝ → ℝ)              -- total cost function
    (revenue : ℝ → ℝ)        -- revenue function
    (hK_pos : 0 < K)
    (hCv0 : C_v 0 = 0)
    (hC0 : C 0 = 0)
    (hCq : ∀ q : ℝ, 0 < q → C q = C_v q + K)
    (profit : ℝ → ℝ)
    (hprofit : ∀ q, profit q = revenue q - C q)
    (q : ℝ)
    (hq_pos : 0 < q)
    (hprod : 0 ≤ profit q)   -- firm chooses to produce (nonneg profit)
    : revenue q ≥ C_v q + K := by
  rw [hprofit] at hprod
  rw [hCq q hq_pos] at hprod
  linarith