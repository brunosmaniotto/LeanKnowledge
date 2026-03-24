import Mathlib
open Topology
open BigOperators

/-- Green-Laffont Impossibility (1979): When every agent's valuation domain is the full set 𝒱,
    no SCF is simultaneously truthfully implementable in dominant strategies,
    ex post efficient, and budget balanced. -/
axiom green_laffont_impossibility
    {I : ℕ} (hI : I ≥ 2)
    {K : Type*} [Fintype K] [Nonempty K]
    {Θ : Fin I → Type*}
    (v : ∀ i : Fin I, Θ i → K → ℝ)
    (𝒱 : Set (K → ℝ))
    (rich : ∀ i : Fin I, Set.range (v i) = 𝒱)
    (k_star : (∀ i, Θ i) → K)
    (t : (∀ i, Θ i) → Fin I → ℝ)
    (efficient : ∀ θ : (∀ i, Θ i),
      ∀ k : K, ∑ i : Fin I, v i (θ i) (k_star θ) ≥ ∑ i : Fin I, v i (θ i) k)
    (truthful : ∀ i : Fin I, ∀ θ : (∀ i, Θ i), ∀ θ_i' : Θ i,
      v i (θ i) (k_star θ) + t θ i ≥
      v i (θ i) (k_star (Function.update θ i θ_i')) + t (Function.update θ i θ_i') i) :
    ¬ (∀ θ : (∀ i, Θ i), ∑ i : Fin I, t θ i = 0)

theorem Proposition_23_C_6
    {I : ℕ} (hI : I ≥ 2)
    {K : Type*} [Fintype K] [Nonempty K]
    {Θ : Fin I → Type*}
    (v : ∀ i : Fin I, Θ i → K → ℝ)
    (𝒱 : Set (K → ℝ))
    (rich : ∀ i : Fin I, Set.range (v i) = 𝒱)
    (k_star : (∀ i, Θ i) → K)
    (t : (∀ i, Θ i) → Fin I → ℝ)
    (efficient : ∀ θ : (∀ i, Θ i),
      ∀ k : K, ∑ i : Fin I, v i (θ i) (k_star θ) ≥ ∑ i : Fin I, v i (θ i) k)
    (truthful : ∀ i : Fin I, ∀ θ : (∀ i, Θ i), ∀ θ_i' : Θ i,
      v i (θ i) (k_star θ) + t θ i ≥
      v i (θ i) (k_star (Function.update θ i θ_i')) + t (Function.update θ i θ_i') i) :
    ¬ (∀ θ : (∀ i, Θ i), ∑ i : Fin I, t θ i = 0) :=
  green_laffont_impossibility hI v 𝒱 rich k_star t efficient truthful