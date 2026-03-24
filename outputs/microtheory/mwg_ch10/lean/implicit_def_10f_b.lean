import Mathlib

open Set
open Topology

-- The individual firm's supply correspondence, mapping price (ℝ) to a set of non-negative quantities (Set NNReal).
-- The individual firm's profit function, mapping price (ℝ) to a real number profit (ℝ).
-- The market demand function, mapping price (ℝ) to a non-negative total quantity demanded (NNReal).

/--
The long-run aggregate supply correspondence `Q(p)` defines the total quantity supplied
at a given price `p`, based on individual firm behavior.

- If individual profit `π(p)` is positive, supply is infinite (`Set.univ` for `NNReal`).
- If individual profit `π(p)` is zero, aggregate supply is composed of non-negative
  integer multiples of individual firm supplies `q ∈ q(p)`.
- If individual profit `π(p)` is negative, long-run supply is zero (`∅`).
-/
noncomputable def longRunAggregateSupplyCorrespondence
    (q_indiv_supply : ℝ → Set NNReal)
    (profit_func : ℝ → ℝ)
    (p : ℝ) : Set NNReal :=
  if (profit_func p) > 0 then
    (univ : Set NNReal) -- Represents infinite supply (all non-negative quantities in NNReal)
  else if (profit_func p) = 0 then
    -- The set of all Q such that Q = J * q for some non-negative integer J and some q in q(p).
    -- `(J : NNReal) * q₀` performs multiplication of a natural number J (cast to NNReal) by an NNReal q₀.
    image2 (fun (J : ℕ) (q₀ : NNReal) => (J : NNReal) * q₀) (univ : Set ℕ) (q_indiv_supply p)
  else
    ∅ -- No long-run supply if profit is negative

/--
A price `p_star` is a long-run competitive equilibrium price if and only if
the market demand at `p_star` is an element of the long-run aggregate supply
correspondence at `p_star`.
-/
def isLongRunCompetitiveEquilibriumPrice
    (q_indiv_supply : ℝ → Set NNReal)
    (profit_func : ℝ → ℝ)
    (market_demand : ℝ → NNReal)
    (p_star : ℝ) : Prop :=
  market_demand p_star ∈ longRunAggregateSupplyCorrespondence q_indiv_supply profit_func p_star