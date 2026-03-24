import Mathlib
open Topology

/--
Conditions on post-entry competition, following Mankiw and Whinston (1986). These
conditions are on an oligopoly model's equilibrium quantity function `q`,
inverse demand function `p`, and marginal cost function `c'`.

The conditions are:
- (A1) `aggregate_output_increases`: Aggregate output `J * q J` is non-decreasing
  in the number of firms `J`.
- (A2) `business_stealing`: Each firm's individual sales `q J` are non-increasing
  in the number of firms `J`.
- (A3) `price_not_below_mc`: Price `p(J * q J)` is not below marginal cost `c'(q J)`.
-/
structure Implicit_Def_12E_c (q : ℕ+ → ℝ) (p : ℝ → ℝ) (c' : ℝ → ℝ) : Prop where
  /-- (A1) Jq_J ≥ J'q_{J'} whenever J > J' (aggregate output increases with entry). -/
  aggregate_output_increases : ∀ {J J' : ℕ+}, J > J' → (J : ℝ) * q J ≥ (J' : ℝ) * q J'
  /-- (A2) q_J ≤ q_{J'} whenever J > J' (business stealing: each firm's sales fall with entry). -/
  business_stealing : ∀ {J J' : ℕ+}, J > J' → q J ≤ q J'
  /-- (A3) p(Jq_J) - c'(q_J) ≥ 0 for all J (price is not below marginal cost). -/
  price_not_below_mc : ∀ (J : ℕ+), p ((J : ℝ) * q J) - c' (q J) ≥ 0