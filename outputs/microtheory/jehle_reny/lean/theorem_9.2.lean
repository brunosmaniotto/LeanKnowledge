import Mathlib

noncomputable section

axiom AuctionSetting : Type
axiom BidStrategy : Type
axiom IsDutchNE : AuctionSetting → BidStrategy → Prop
axiom IsFirstPriceNE : AuctionSetting → BidStrategy → Prop
axiom eqBid : AuctionSetting → BidStrategy

axiom strategic_equiv (A : AuctionSetting) (β : BidStrategy) :
    IsDutchNE A β ↔ IsFirstPriceNE A β

axiom thm_9_1 (A : AuctionSetting) :
    IsFirstPriceNE A (eqBid A) ∧ ∀ β, IsFirstPriceNE A β → β = eqBid A

theorem Theorem_9_2 (A : AuctionSetting) :
    IsDutchNE A (eqBid A) ∧ ∀ β, IsDutchNE A β → β = eqBid A := by
  obtain ⟨h1, h2⟩ := thm_9_1 A
  exact ⟨(strategic_equiv A _).mpr h1, fun β hβ => h2 β ((strategic_equiv A β).mp hβ)⟩