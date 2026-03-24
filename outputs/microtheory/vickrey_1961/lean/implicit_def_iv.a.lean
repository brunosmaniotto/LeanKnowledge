import Mathlib
open Topology

/-- A symmetric bidding strategy in a first-price auction (Vickrey 1961, Def IV.A).
    Each bidder draws a private value `v` and submits bid `x v`.
    By symmetry, all bidders use the same function. -/
noncomputable def symmetricBiddingStrategy (x : ℝ → ℝ) (n : ℕ) (i : Fin n) (v : Fin n → ℝ) : ℝ :=
  x (v i)