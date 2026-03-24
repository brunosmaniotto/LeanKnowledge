import Mathlib

open Set
open Topology

/-- A symmetric Nash equilibrium in strictly increasing bidding functions
    (Jehle & Reny, Def 9.2.1).

    `U σ v x` is the expected payoff when other bidders use strategy `σ`,
    the bidder's private value is `v`, and the bidder submits bid `x`.

    A function `b : ℝ → ℝ` is a symmetric NE if it is strictly increasing,
    maps `[0,1]` to nonnegative reals, and for every value `v ∈ [0,1]`,
    bidding `b v` maximises expected payoff given all others also play `b`. -/
structure IsSymmetricNE
    (U : (ℝ → ℝ) → ℝ → ℝ → ℝ)
    (b : ℝ → ℝ) : Prop where
  strictMono : StrictMono b
  nonneg : ∀ v ∈ Icc (0 : ℝ) 1, 0 ≤ b v
  optimal : ∀ v ∈ Icc (0 : ℝ) 1, ∀ x : ℝ, 0 ≤ x →
    U b v x ≤ U b v (b v)