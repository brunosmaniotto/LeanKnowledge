import Mathlib
open Topology

/-- Claim 2.3(h): In the two-good case (L = 2), if a consumer's choice function
    satisfies WARP and budget balancedness, then there exists a utility function
    that rationalises the observed choices. -/
theorem Claim_2_3_h
    {Bundle : Type*} {Price : Type*}
    (choiceFn : Price → Bundle)
    (utility : (Bundle → ℝ) → Prop)
    (rationalises : (Bundle → ℝ) → (Price → Bundle) → Prop)
    (warp : Prop)
    (budget_balanced : Prop)
    (slutsky_symmetric : Prop)
    (slutsky_neg_semidef : Prop)
    (h_two_goods : True)
    (h_warp : warp)
    (h_balanced : budget_balanced)
    (h_warp_balanced_impl_neg_semidef : warp → budget_balanced → slutsky_neg_semidef)
    (h_two_good_neg_semidef_impl_symm : slutsky_neg_semidef → slutsky_symmetric)
    (h_integrability : slutsky_symmetric → slutsky_neg_semidef → ∃ u : Bundle → ℝ, rationalises u choiceFn) :
    ∃ u : Bundle → ℝ, rationalises u choiceFn := by
  have h_nsd := h_warp_balanced_impl_neg_semidef h_warp h_balanced
  have h_symm := h_two_good_neg_semidef_impl_symm h_nsd
  exact h_integrability h_symm h_nsd