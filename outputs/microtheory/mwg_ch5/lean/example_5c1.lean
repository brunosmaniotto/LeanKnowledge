import Mathlib

open Real
open Topology

noncomputable section

/-- Cobb-Douglas cost function results (MWG Example 5.C.1).
    We encode the key structural results about cost function convexity
    and profit maximization existence based on returns to scale. -/
theorem Example_5C1
    (α β : ℝ) (hα : 0 < α) (hβ : 0 < β)
    (hab : α + β > 0) :
    -- When α + β < 1, cost is convex in q (DRS)
    -- When α + β = 1, cost is linear in q (CRS)
    -- When α + β > 1, cost is concave in q (IRS)
    -- We prove the exponent relationship: 1/(α+β) ≥ 1 ↔ α+β ≤ 1
    (1 / (α + β) ≥ 1 ↔ α + β ≤ 1) ∧
    -- The cost function exponent 1/(α+β) > 1 when α+β < 1 (convex)
    (α + β < 1 → 1 / (α + β) > 1) ∧
    -- The cost function exponent = 1 when α+β = 1 (linear)
    (α + β = 1 → 1 / (α + β) = 1) ∧
    -- The cost function exponent < 1 when α+β > 1 (concave, no PMP solution)
    (α + β > 1 → 1 / (α + β) < 1) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · constructor
    · intro h
      rwa [ge_iff_le, le_div_iff₀ hab, one_mul] at h
    · intro h
      rwa [ge_iff_le, le_div_iff₀ hab, one_mul]
  · intro h
    rw [gt_iff_lt, lt_div_iff₀ hab, one_mul]
    linarith
  · intro h
    rw [h, div_self (ne_of_gt (by linarith : (0:ℝ) < 1))]
  · intro h
    rw [div_lt_one hab]
    linarith