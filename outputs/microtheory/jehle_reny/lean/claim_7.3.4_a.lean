import Mathlib
open BigOperators ProbabilityTheory Finset
open Topology

-- The claim describes the properties of a "finite extensive form game".
-- We formalize this by creating a structure that holds these properties.
-- The player set `I` is a variable for the whole section.
variable {I : Type*} [Fintype I] [DecidableEq I]

/--
Formalization of Claim 7.3.4a. A finite extensive form game has finite pure strategy
sets for each player. The outcome and payoffs are determined by the players' chosen
strategies and a move by Nature. A player's expected utility can then be calculated
based on Nature's probability distribution over its moves.
-/
structure FiniteExtensiveFormGame where
  /-- A type for the pure strategies for each player. -/
  S : I → Type*
  /-- The pure strategy set for each player is finite. -/
  [s_fintype : ∀ i, Fintype (S i)]
  /-- The type of initial moves by Nature/Chance. -/
  ChanceOutcomes : Type*
  /-- A proof that Nature's set of moves is finite. -/
  [chance_fintype : Fintype ChanceOutcomes]
  /-- A proof that Nature's moves can be compared for equality. -/
  [chance_dec_eq : DecidableEq ChanceOutcomes]
  /-- Nature's probability distribution over its initial moves. -/
  chance_dist : PMF ChanceOutcomes
  /--
  The utility (payoff) for player `i`, which is determined by the joint pure
  strategy `s` of all players and Nature's chosen move `c`.
  -/
  utility : I → ((j : I) → S j) → ChanceOutcomes → ℝ

namespace FiniteExtensiveFormGame

-- Promote the instance fields to be available globally for any `G : FiniteExtensiveFormGame`.
attribute [instance] s_fintype chance_fintype chance_dec_eq

/--
Player `i`'s expected utility for a given joint strategy `s`. This is the
sum of utilities from each of Nature's possible moves, weighted by the
probability of that move.
-/
noncomputable def expectedUtility (G : FiniteExtensiveFormGame) (i : I) (s : (j : I) → G.S j) : ℝ :=
  -- The expected utility is the sum over all of Nature's moves `c`,
  -- of the utility from that move `G.utility i s c`
  -- multiplied by the probability of that move.
  -- We use `.toReal` to convert the probability from `ENNReal` to `ℝ`.
  ∑ c : G.ChanceOutcomes, (G.chance_dist c).toReal * G.utility i s c

end FiniteExtensiveFormGame