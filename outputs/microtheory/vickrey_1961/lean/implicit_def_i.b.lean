import Mathlib

/-- An imperfectly competitive market for a standardized commodity.

Either buyers or sellers (or both) are too few in number to ignore the
repercussions of their actions on the market price, but participants are
either too numerous, too naive, or too isolated from each other to engage
in any overtly or tacitly concerted action. -/
structure ImperfectlyCompetitiveMarket (Participant : Type*) where
  /-- Classifies each participant as a buyer (true) or seller (false) -/
  isBuyer : Participant → Prop
  /-- Whether a group has enough market power to influence the market price -/
  hasPriceInfluence : Set Participant → Prop
  /-- Whether a group is able to engage in concerted (overt or tacit) action -/
  canActConcertedly : Set Participant → Prop
  /-- At least one side has too few members to ignore price repercussions -/
  some_side_influences_price :
    hasPriceInfluence {p | isBuyer p} ∨ hasPriceInfluence {p | ¬isBuyer p}
  /-- Buyers cannot engage in concerted action -/
  buyers_no_concerted_action : ¬canActConcertedly {p | isBuyer p}
  /-- Sellers cannot engage in concerted action -/
  sellers_no_concerted_action : ¬canActConcertedly {p | ¬isBuyer p}