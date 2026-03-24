import Mathlib
open Topology

namespace Claim_VI

-- The claim describes two types of auction situations.
inductive AuctionSituation
| less_determinate
| more_determinate

-- To formalize the claim, we create a model of the situation. This captures the
-- essential concepts: auction types, an advantage function depending on a bidder's
-- information level, and properties (axioms) that encode the economic intuition.
-- We make `InformationLevel` a parameter to the structure, along with its `LinearOrder` instance.
structure BiddingModel (InformationLevel : Type) [LinearOrder InformationLevel] where
  -- The Advantage is a function mapping the auction situation and information level
  -- to a real-valued payoff or utility.
  Advantage : AuctionSituation → InformationLevel → ℝ

  -- Property 1: In the 'less determinate' auction, more information provides a greater advantage.
  -- This captures "the advantage which their superior information gives them".
  advantage_increases_with_info :
    ∀ {i₁ i₂ : InformationLevel}, i₁ > i₂ → Advantage .less_determinate i₁ > Advantage .less_determinate i₂

  -- Property 2: In the 'more determinate' auction (e.g., progressive auction), the optimal
  -- strategy is simple (bid full value), so information about others is irrelevant.
  -- We model this by stating the advantage is constant regardless of information level.
  advantage_constant_in_determinate_case :
    ∀ (i₁ i₂ : InformationLevel), Advantage .more_determinate i₁ = Advantage .more_determinate i₂

  -- Property 3: The less informed bidders gain from the change. Their lack of information is
  -- no longer a handicap. We model this as their advantage being strictly greater in the
  -- 'more determinate' situation, which removes sources of strategic error.
  uninformed_gains :
    ∀ (i : InformationLevel), Advantage .more_determinate i > Advantage .less_determinate i

-- Within any system that fits our model, we can state and prove the claim.
-- The theorem has two parts, corresponding to the two main clauses in the original text.
theorem H {InformationLevel : Type} [LinearOrder InformationLevel] (model : BiddingModel InformationLevel)
    {i_high i_low : InformationLevel} (h_info : i_high > i_low) :
  -- 1. "bidders who have relatively greater knowledge ... lose the advantage"
  -- We interpret this as the *gap* in advantage between more and less informed bidders
  -- shrinking (in our model, it is eliminated, going from positive to zero).
  (model.Advantage .less_determinate i_high - model.Advantage .less_determinate i_low >
   model.Advantage .more_determinate i_high - model.Advantage .more_determinate i_low) ∧
  -- 2. "whereas the less informed bidders tend to gain"
  -- This is a direct statement about the payoff for a bidder with a given information level.
  (model.Advantage .more_determinate i_low > model.Advantage .less_determinate i_low) := by
  constructor
  -- Proof of part 1:
  -- The advantage gap in the determinate case is zero because advantage is constant.
  -- The advantage gap in the less determinate case is positive due to superior information.
  -- A positive number is greater than zero.
  {
    -- Apply the property that advantage is constant in the more determinate case, making the RHS 0.
    rw [model.advantage_constant_in_determinate_case i_high i_low]
    -- Simplify `X - X` to `0` and potentially `A - B > 0` to `A > B`.
    simp
    -- The goal is now `model.Advantage .less_determinate i_high > model.Advantage .less_determinate i_low`
    -- This follows directly from the first property of our model.
    exact (model.advantage_increases_with_info h_info)
  }
  -- Proof of part 2:
  -- This follows directly from the third property of our model.
  {
    exact model.uninformed_gains i_low
  }

end Claim_VI