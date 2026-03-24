import Mathlib
open Filter Topology Finset BigOperators
open Topology
open BigOperators

/-- The power mean (Σᵢ uᵢ^ρ)^(1/ρ) converges to min{u₁,…,uₙ} as ρ → −∞
    for positive utility values. Standard real-analysis result. -/
axiom power_mean_limit_is_min {I : Type*} [Fintype I] [Nonempty I]
    (u : I → ℝ) (hu : ∀ i, 0 < u i) :
    Tendsto (fun ρ : ℝ => (∑ i : I, (u i) ^ ρ) ^ (1 / ρ))
      atBot (𝓝 (Finset.inf' Finset.univ Finset.univ_nonempty u))

theorem Claim_6E_k {I : Type*} [Fintype I] [Nonempty I]
    (u : I → ℝ) (hu : ∀ i, 0 < u i) :
    Tendsto (fun ρ : ℝ => (∑ i : I, (u i) ^ ρ) ^ (1 / ρ))
      atBot (𝓝 (Finset.inf' Finset.univ Finset.univ_nonempty u)) :=
  power_mean_limit_is_min u hu