import Mathlib

/-- If adjacent regions (relative to ū) are both ranked the same way relative to ū
    under the social welfare function W, then the boundary separating those two regions
    is also ranked the same way relative to ū.

    We model this via a preorder: if a boundary point `b` weakly dominates some point `r`
    in region II (by Weak Pareto, since `b` is componentwise ≥ `r`), and `r` is ranked
    above `ū`, then by transitivity `b` is also ranked above `ū`. -/
theorem claim_6B_b
    {α : Type*} [Preorder α]
    (ū b r : α)
    (h_wp : r ≤ b)
    (h_region : ū ≤ r) :
    ū ≤ b := by
  exact le_trans h_region h_wp