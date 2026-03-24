import Mathlib
open Topology

/-- A contingent contract `(q, k, t, s)` entitles the bearer to `q` units of
    basic good `k` at date `t` in state `s`. -/
structure ContingentContract (K : Type*) (T : Type*) (S : Type*) where
  /-- Non-negative quantity of the basic good -/
  quantity : ℝ
  /-- Index of the basic good -/
  good : K
  /-- Date of delivery -/
  date : T
  /-- State of the world in which delivery occurs -/
  state : S
  /-- The quantity specified in a contract is non-negative -/
  quantity_nonneg : 0 ≤ quantity

/-- Net contract position for agent with consumption `x` and endowment `e`
    at commodity index `(k, t, s)`. Positive means the agent receives from
    the market; negative means the agent supplies to the market. -/
noncomputable def netContractPosition
    {K : Type*} {T : Type*} {S : Type*}
    (x e : K → T → S → ℝ) (k : K) (t : T) (s : S) : ℝ :=
  x k t s - e k t s