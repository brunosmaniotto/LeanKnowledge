import Mathlib
open Topology
open BigOperators

/-
**Definition** (Implicit_Def_11C_b):
In the private provision model, each consumer i chooses how much of the public good to buy, x_i ≥ 0,
at market price p, taking others' purchases as given. The total public good is x = Σ_i x_i.
A single profit-maximizing firm with cost function c(·) chooses production taking the market price as given.
-/
structure PrivateProvisionModel (Consumer : Type u) where
  -- The finite set of consumers participating in this model.
  consumers : Finset Consumer
  -- The market price of the public good.
  market_price : ℝ
  -- The market price must be non-negative.
  market_price_nonneg : 0 ≤ market_price
  -- A function mapping each consumer to their chosen quantity of the public good.
  consumer_choices : Consumer → ℝ
  -- Each consumer's chosen quantity of the public good must be non-negative.
  consumer_choices_nonneg : ∀ i ∈ consumers, 0 ≤ consumer_choices i
  -- The firm's cost function, which maps the total quantity of the public good to its cost.
  cost_function : ℝ → ℝ

  -- The total quantity of the public good, derived as the sum of individual consumer choices.
  def total_public_good (self : PrivateProvisionModel Consumer) : ℝ :=
    ∑ i ∈ self.consumers, self.consumer_choices i