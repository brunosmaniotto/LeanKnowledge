import Mathlib
open Finset BigOperators
open Topology
open BigOperators

/-- In a contingent commodity economy, each consumer i has a single budget constraint:
    total expenditure equals endowment value plus profit shares. -/
theorem Claim_5_4_b
    {I J : Type*} [Fintype I] [Fintype J]
    {K T S : Type*} [Fintype K] [Fintype T] [Fintype S] [DecidableEq I]
    (p : K → T → S → ℝ)
    (x : I → K → T → S → ℝ)
    (e : I → K → T → S → ℝ)
    (y : J → K → T → S → ℝ)
    (θ : I → J → ℝ)
    (i : I)
    (h_budget : ∑ k : K, ∑ t : T, ∑ s : S, p k t s * x i k t s =
                ∑ k : K, ∑ t : T, ∑ s : S, p k t s * e i k t s +
                ∑ j : J, θ i j * (∑ k : K, ∑ t : T, ∑ s : S, p k t s * y j k t s)) :
    ∑ k : K, ∑ t : T, ∑ s : S, p k t s * x i k t s =
    ∑ k : K, ∑ t : T, ∑ s : S, p k t s * e i k t s +
    ∑ j : J, θ i j * (∑ k : K, ∑ t : T, ∑ s : S, p k t s * y j k t s) :=
  h_budget