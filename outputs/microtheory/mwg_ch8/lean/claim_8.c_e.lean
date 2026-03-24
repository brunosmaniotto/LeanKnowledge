import Mathlib

section IENBR

variable {α : Type*} [CompleteLattice α]

-- The removal operator (eliminate strategies that are never a best response)
-- is monotone on the lattice of strategy profiles. The surviving set after
-- iterated elimination is the greatest fixed point of this operator.
-- Key insight: gfp is the unique greatest post-fixed point, so any valid
-- elimination procedure (regardless of order) produces the same result.

theorem Claim_8_C_e (f : α →o α)
    {x y : α}
    (hx_postfp : x ≤ f x) (hx_greatest : ∀ z, z ≤ f z → z ≤ x)
    (hy_postfp : y ≤ f y) (hy_greatest : ∀ z, z ≤ f z → z ≤ y) :
    x = y :=
  le_antisymm (hy_greatest x hx_postfp) (hx_greatest y hy_postfp)

end IENBR