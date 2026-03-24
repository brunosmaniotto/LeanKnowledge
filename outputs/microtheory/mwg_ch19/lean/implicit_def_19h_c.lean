import Mathlib
open Topology

universe u

/-- The pooled information equilibrium price function.
    Given individual signal functions σ_i for each consumer, the pooled price
    is the market-clearing price when all signals are public knowledge. -/
noncomputable def pooledInfoEquilibriumPrice
    {I : Type*} [Fintype I]
    {S : Type*}       -- state space
    {SignalSpace : I → Type*}  -- each consumer's signal space
    {P : Type*}       -- price space
    (σ : (i : I) → S → SignalSpace i)  -- individual signal functions
    (marketClearingPrice : ((i : I) → SignalSpace i) → P)  -- price from pooled signals
    (s : S) : P :=
  marketClearingPrice (fun i => σ i s)