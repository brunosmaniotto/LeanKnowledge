import Mathlib
open Topology

/-- Counterspeculation is a strategy employed by a state agency in an
    imperfectly competitive market that creates conditions maintaining the
    marginal conditions for efficient resource allocation
    (Lerner, *Economics of Control*). -/
structure Counterspeculation (Market Strategy Allocation : Type*) where
  /-- Predicate: the market exhibits imperfect competition -/
  imperfectlyCompetitive : Market → Prop
  /-- Predicate: marginal conditions for efficient resource allocation hold -/
  marginalEfficiency : Allocation → Prop
  /-- The allocation outcome when a strategy is applied to a market -/
  outcome : Strategy → Market → Allocation
  /-- The imperfectly competitive market -/
  market : Market
  /-- The state agency's strategy -/
  strategy : Strategy
  /-- The market is imperfectly competitive -/
  market_imperfect : imperfectlyCompetitive market
  /-- Applying the strategy restores marginal conditions for efficiency -/
  restores_efficiency : marginalEfficiency (outcome strategy market)