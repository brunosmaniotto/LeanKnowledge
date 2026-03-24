import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A free-disposal quasiequilibrium for a private ownership economy.
Components: consumption bundles x*, production plans y*, and a nonzero price vector p,
satisfying profit maximization, budget/quasiequilibrium conditions, and free-disposal feasibility
with complementary slackness. -/
structure FreeDisposalQuasiequilibrium
    (I : Type*) [Fintype I]   -- consumers
    (J : Type*) [Fintype J]   -- firms
    (L : Type*) [Fintype L] [DecidableEq L]  -- commodities
    (Y : J → Set (L → ℝ))     -- production sets
    (pref : I → (L → ℝ) → (L → ℝ) → Prop)  -- strict preference ≻_i
    (ω : I → (L → ℝ))        -- endowments
    (θ : I → J → ℝ)          -- ownership shares
    where
  x : I → (L → ℝ)            -- consumption allocation x*
  y : J → (L → ℝ)            -- production plan y*
  p : L → ℝ                  -- price vector
  p_nonzero : p ≠ 0
  /-- (i) Profit maximization: each firm j maximizes profit at y_j* -/
  profit_max : ∀ j : J, ∀ yj ∈ Y j,
    ∑ l, p l * yj l ≤ ∑ l, p l * (y j) l
  /-- (ii') Budget feasibility: each consumer's expenditure ≤ wealth -/
  budget : ∀ i : I,
    ∑ l, p l * (x i) l ≤
      ∑ l, p l * (ω i) l + ∑ j, θ i j * ∑ l, p l * (y j) l
  /-- (ii') Quasiequilibrium: if x_i is strictly preferred to x_i*, then x_i costs at least wealth -/
  quasi : ∀ i : I, ∀ xi : L → ℝ, pref i xi (x i) →
    ∑ l, p l * xi l ≥
      ∑ l, p l * (ω i) l + ∑ j, θ i j * ∑ l, p l * (y j) l
  /-- (iii') Free-disposal feasibility: aggregate consumption ≤ aggregate endowment + production -/
  feasibility : ∀ l : L,
    ∑ i, (x i) l ≤ ∑ i, (ω i) l + ∑ j, (y j) l
  /-- (iii') Complementary slackness: excess supply has zero value -/
  complementary_slackness :
    ∑ l, p l * (∑ i, (x i) l - ∑ i, (ω i) l - ∑ j, (y j) l) = 0