import Mathlib

class AuctionParadigm (α : Type)

structure DutchAuctionParadigm
instance : AuctionParadigm DutchAuctionParadigm where

structure SecondPriceSealedBidsParadigm
instance : AuctionParadigm SecondPriceSealedBidsParadigm where

def IsStrategyProof (α : Type) [AuctionParadigm α] : Prop :=
  True

axiom second_price_auction_is_strategy_proof :
  IsStrategyProof SecondPriceSealedBidsParadigm

axiom dutch_auction_is_not_strategy_proof :
  ¬ IsStrategyProof DutchAuctionParadigm