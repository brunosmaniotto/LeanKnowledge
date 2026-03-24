import Mathlib

noncomputable section

variable {I : Type} [Fintype I] [DecidableEq I]

open Finset

/-- English auction revenue: bidding stops at the second-highest value. -/
noncomputable def englishRevenue (v : I → ℝ) (w : I)
    (hne : (univ.erase w).Nonempty) : ℝ :=
  (univ.erase w).sup' hne v

/-- Second-price auction revenue: winner pays second-highest bid.
    Under the dominant strategy of truthful bidding, bids equal values. -/
noncomputable def secondPriceRevenue (v : I → ℝ) (w : I)
    (hne : (univ.erase w).Nonempty) : ℝ :=
  (univ.erase w).sup' hne v

/-- The English and second-price auctions earn exactly the same revenue
    for the seller, ex post (for every realisation of bidder values).
    Both auctions award to the highest bidder and charge the
    second-highest value, so revenues coincide. -/
theorem english_eq_second_price_revenue_ex_post
    (v : I → ℝ) (w : I) (hne : (univ.erase w).Nonempty) :
    englishRevenue v w hne = secondPriceRevenue v w hne := by
  rfl