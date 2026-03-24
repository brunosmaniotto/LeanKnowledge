import Mathlib

open BigOperators
open Finset
open Topology

/--
This definition formalizes the statement of Claim I.C. The claim is not a
mathematical theorem that can be proven from axioms in Mathlib, but rather a
qualitative statement from economics. This definition translates the concepts
of the claim into a formal logical proposition (`Prop`) in Lean.

It describes a scenario with buyers, sellers, and a price-setting agency,
and asserts that if agents can misrepresent their preferences, they will have an
incentive to do so, making it difficult for the agency to determine the true
equilibrium price.

We don't prove this proposition, as that would require a specific economic model.
Instead, we state it formally to capture its logical structure.
-/
def Claim_I_C : Prop :=
  -- For any set of buyers and sellers...
  ∀ (Buyer Seller : Type) [DecidableEq Buyer] [DecidableEq Seller]
    -- ... and any finite collection of them in the market...
    (buyers : Finset Buyer) (sellers : Finset Seller),
    -- ... with their true demand, supply, and utility functions...
    ∀ (true_demand : Buyer → ℝ → ℝ) (true_supply : Seller → ℝ → ℝ)
      (buyer_utility : Buyer → ℝ → ℝ → ℝ) (seller_utility : Seller → ℝ → ℝ → ℝ)
      -- ... and a price-setting mechanism used by the agency...
      (set_price : (ℝ → ℝ) → (ℝ → ℝ) → ℝ),
      -- ... if agents can report different demand/supply functions...
      ∀ (reported_demand : Buyer → ℝ → ℝ) (reported_supply : Seller → ℝ → ℝ),

        -- ... THEN the following two conditions hold:

        -- 1. Incentive to Misrepresent:
        -- There exists a situation where an agent is better off lying, assuming
        -- others are truthful.
        ( (∃ (b : Buyer) (b_fin : b ∈ buyers) (alt_demand : ℝ → ℝ),
            (alt_demand ≠ true_demand b) ∧
            let p_truthful := set_price
              (fun p => ∑ b' ∈ buyers, true_demand b' p)
              (fun p => ∑ s' ∈ sellers, true_supply s' p)
            let p_manipulated := set_price
              (fun p => (∑ b' ∈ buyers.erase b, true_demand b' p) + alt_demand p)
              (fun p => ∑ s' ∈ sellers, true_supply s' p)
            buyer_utility b p_manipulated (alt_demand p_manipulated) >
            buyer_utility b p_truthful (true_demand b p_truthful)
          ) ∨
          (∃ (s : Seller) (s_fin : s ∈ sellers) (alt_supply : ℝ → ℝ),
             (alt_supply ≠ true_supply s) ∧
             let p_truthful := set_price
               (fun p => ∑ b' ∈ buyers, true_demand b' p)
               (fun p => ∑ s' ∈ sellers, true_supply s' p)
             let p_manipulated := set_price
               (fun p => ∑ b' ∈ buyers, true_demand b' p)
               (fun p => (∑ s' ∈ sellers.erase s, true_supply s' p) + alt_supply p)
             seller_utility s p_manipulated (alt_supply p_manipulated) >
             seller_utility s p_truthful (true_supply s p_truthful)
          )
        ) ∧
        -- 2. Difficulty in Ascertaining True Equilibrium:
        -- If any agent misrepresents their preferences, the price set by the agency
        -- will not be the true equilibrium price.
        ( ( (∃ b ∈ buyers, reported_demand b ≠ true_demand b) ∨
            (∃ s ∈ sellers, reported_supply s ≠ true_supply s) ) →
            let p_agency := set_price
              (fun p => ∑ b ∈ buyers, reported_demand b p)
              (fun p => ∑ s ∈ sellers, reported_supply s p)
            (∑ b ∈ buyers, true_demand b p_agency) ≠ (∑ s ∈ sellers, true_supply s p_agency)
        )