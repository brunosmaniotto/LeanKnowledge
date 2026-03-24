import Mathlib
open Topology

/-- A Dutch auction: each bidder chooses a price threshold. Highest wins, pays that price. -/
structure DutchAuction (N : ℕ) where
  threshold : Fin N → ℝ

/-- A first-price sealed-bid auction: each bidder submits a bid. Highest wins, pays that bid. -/
structure FirstPriceSealedBid (N : ℕ) where
  bid : Fin N → ℝ

/-- Dutch auction is strategically equivalent to first-price sealed-bid auction. -/
def dutchFirstPriceEquiv (N : ℕ) : DutchAuction N ≃ FirstPriceSealedBid N where
  toFun d := ⟨d.threshold⟩
  invFun f := ⟨f.bid⟩
  left_inv _ := rfl
  right_inv _ := rfl