import Mathlib
open Topology

structure REEconomy where
  State : Type
  Agent : Type
  Price : Type
  signal : Agent → State → Set State
  priceFunc : State → Price
  clears : (Agent → State → Set State) → State → Prop

noncomputable def REEconomy.pooledInfo (E : REEconomy) (s : E.State) : Set E.State :=
  ⋂ i : E.Agent, E.signal i s

def REEconomy.priceInfo (E : REEconomy) [DecidableEq E.Price] (s : E.State) : Set E.State :=
  {s' | E.priceFunc s' = E.priceFunc s}