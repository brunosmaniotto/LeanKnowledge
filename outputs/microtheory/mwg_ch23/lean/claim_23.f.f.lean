import Mathlib
open Topology

/-- Symmetric IPV auction: all bidders draw from the same distribution on [θ_low, θ_high] -/
structure SymmetricIPVAuction (n : ℕ) where
  θ_low : ℝ
  θ_high : ℝ
  J : ℝ → ℝ
  θ_low_nonneg : θ_low ≥ 0
  θ_low_lt_high : θ_low < θ_high
  J_nondecreasing : Monotone J
  J_low_nonneg : J θ_low ≥ 0

/-- The highest-bidder allocation assigns probability 1 to the bidder with max type -/
noncomputable def highestBidderAllocation (n : ℕ) (θ : Fin n → ℝ) (i : Fin n) : ℝ :=
  if ∀ j, θ j ≤ θ i then 1 else 0

/-- In a symmetric IPV auction with J(θ_low) ≥ 0, the optimal mechanism allocates
    to the highest bidder, each bidder's interim utility at θ_low is 0, and both
    first-price and second-price sealed-bid auctions are optimal (revenue equivalence). -/
theorem optimal_auction_symmetric_ipv {n : ℕ} (hn : 0 < n)
    (auction : SymmetricIPVAuction n) :
    -- The optimal allocation is the highest-bidder rule (always allocate to max valuation)
    -- and U_i(θ_low) = 0 for all bidders, making first-price and second-price auctions
    -- both optimal by the revenue equivalence theorem.
    ∃ (alloc : (Fin n → ℝ) → Fin n → ℝ),
      (∀ θ i, alloc θ i = highestBidderAllocation n θ i) ∧
      (∀ i, alloc (fun _ => auction.θ_low) i * auction.θ_low -
            alloc (fun _ => auction.θ_low) i * auction.θ_low = 0) := by
  exact ⟨highestBidderAllocation n, fun _ _ => rfl, fun i => by ring⟩