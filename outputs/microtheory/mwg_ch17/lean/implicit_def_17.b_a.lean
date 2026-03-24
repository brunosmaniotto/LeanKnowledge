import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Production inclusive excess demand function for a production economy.
    Given I consumers and J firms, maps strictly positive prices to excess demand vectors.
    ẑ(p) = Σ_i x_i(p, w_i(p)) − Σ_i ω_i − Σ_j y_j(p)
    where w_i(p) = p · ω_i + Σ_j θ_{ij} π_j(p) is consumer i's wealth. -/
noncomputable def productionExcessDemand
    (n : ℕ)                                          -- number of commodities
    (I : Finset ι)                                    -- set of consumers
    (J : Finset κ)                                    -- set of firms
    (x : ι → (Fin n → ℝ) → ℝ → (Fin n → ℝ))        -- consumer demand: agent → prices → wealth → bundle
    (ω : ι → (Fin n → ℝ))                            -- endowments per consumer
    (θ : ι → κ → ℝ)                                  -- ownership shares θ_{ij}
    (π : κ → (Fin n → ℝ) → ℝ)                        -- profit function: firm → prices → max profit
    (y : κ → (Fin n → ℝ) → (Fin n → ℝ))             -- supply function: firm → prices → production plan
    (p : Fin n → ℝ)                                   -- price vector (assumed p >> 0)
    : Fin n → ℝ :=
  fun l =>
    -- Σ_i x_i(p, w_i(p))
    (∑ i ∈ I, x i p (∑ l', p l' * ω i l' + ∑ j ∈ J, θ i j * π j p) l)
    -- − Σ_i ω_i
    - (∑ i ∈ I, ω i l)
    -- − Σ_j y_j(p)
    - (∑ j ∈ J, y j p l)