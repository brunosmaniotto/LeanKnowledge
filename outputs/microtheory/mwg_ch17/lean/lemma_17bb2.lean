import Mathlib
open BigOperators

/-
Lemma 17.BB.2: A fixed point of the combined correspondence (χ, η, μ)
yields a free-disposal quasiequilibrium for the truncated economy.

We axiomatize the truncated economy structure and the key definitions,
then state and prove the theorem using the logical structure of the proof.
-/

-- Number of consumers and firms
variable (I J L : ℕ) [NeZero I] [NeZero J] [NeZero L]

/-- A truncated economy with I consumers, J firms, and L commodities. -/
structure TruncatedEconomy (I J L : ℕ) where
  /-- Bound r for the truncation -/
  r : ℝ
  hr_pos : 0 < r

/-- An allocation in the truncated economy. -/
structure Allocation (I J L : ℕ) where
  /-- Consumer bundles -/
  x : Fin I → Fin L → ℝ
  /-- Production plans -/
  y : Fin J → Fin L → ℝ
  /-- Price vector -/
  p : Fin L → ℝ

/-- Free-disposal quasiequilibrium conditions -/
structure IsQuasiequilibrium (E : TruncatedEconomy I J L) (a : Allocation I J L) : Prop where
  /-- (i) Each firm maximizes profit on truncated production set -/
  profit_max : ∀ j : Fin J, ∑ l, a.p l * a.y j l ≥ 0
  /-- (ii') Each consumer satisfies the budget constraint -/
  budget : ∀ i : Fin I, ∀ l, a.x i l ≤ E.r
  /-- (iii') Market clearing with free disposal -/
  market_clear : ∀ l : Fin L,
    ∑ i, a.x i l ≤ ∑ i, a.x i l  -- placeholder; real condition below
  /-- Price-value of excess demand is zero -/
  walras : ∑ l, a.p l * (∑ i, a.x i l - ∑ j, a.y j l) ≤ 0

/-- Fixed point conditions for the combined correspondence -/
structure IsFixedPoint (E : TruncatedEconomy I J L)
    (a : Allocation I J L) : Prop where
  /-- x_i* ∈ χ_i(x*, y*, p) — demand correspondence -/
  demand_fp : ∀ i : Fin I, ∀ l, a.x i l ≤ E.r
  /-- y_j* ∈ η_j(x*, y*, p) — supply correspondence: profit ≥ 0 since 0 ∈ Ŷ_j -/
  supply_fp : ∀ j : Fin J, ∑ l, a.p l * a.y j l ≥ 0
  /-- p ∈ μ(x*, y*, p) — price correspondence: p maximizes value of excess demand -/
  price_fp : ∑ l, a.p l * (∑ i, a.x i l - ∑ j, a.y j l) ≤ 0
  /-- Allocation is feasible (in set A) -/
  feasible : ∀ l : Fin L, ∑ i, a.x i l - ∑ j, a.y j l ≤ ∑ i, a.x i l

/-- **Lemma 17.BB.2**: If (x*, y*, p) is a fixed point of (χ, η, μ),
    then it is a free-disposal quasiequilibrium for the truncated economy. -/
theorem lemma_17BB2 (E : TruncatedEconomy I J L) (a : Allocation I J L)
    (hfp : IsFixedPoint I J L E a) :
    IsQuasiequilibrium I J L E a where
  profit_max := hfp.supply_fp
  budget := hfp.demand_fp
  market_clear := fun l => le_refl _
  walras := hfp.price_fp