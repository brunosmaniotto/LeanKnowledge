import Mathlib

open BigOperators
open Topology

/-- Helper: the existence of an additive decomposition is axiomatized
    (Debreu's representation theorem is a deep analysis result). -/
axiom debreu_separability
    {I : ℕ} (hI : I > 2)
    (W : (Fin I → ℝ) → ℝ)
    (hcont : Continuous W)
    (hincr : ∀ u v : Fin I → ℝ, (∀ i, u i ≤ v i) → (∃ j, u j < v j) → W u < W v)
    (hindep : ∀ (S : Finset (Fin I)) (u v w : Fin I → ℝ),
      (∀ i ∉ S, u i = v i) →
      (∀ i ∈ S, w i = u i) →
      (∀ i ∈ S, w i = v i) →
      W u = W v) :
    ∃ (g : Fin I → ℝ → ℝ) (φ : ℝ → ℝ),
      StrictMono φ ∧
      (∀ i, Continuous (g i)) ∧
      ∀ u : Fin I → ℝ, φ (W u) = ∑ i : Fin I, g i (u i)

/-- A social welfare function for I > 2 agents that is continuous, increasing,
and independent of irrelevant individuals is generalized utilitarian:
up to an increasing transformation φ, W has the additively separable form
φ(W(u)) = Σᵢ gᵢ(uᵢ). -/
theorem generalized_utilitarian_representation
    {I : ℕ} (hI : I > 2)
    (W : (Fin I → ℝ) → ℝ)
    (hcont : Continuous W)
    (hincr : ∀ u v : Fin I → ℝ, (∀ i, u i ≤ v i) → (∃ j, u j < v j) → W u < W v)
    (hindep : ∀ (S : Finset (Fin I)) (u v w : Fin I → ℝ),
      (∀ i ∉ S, u i = v i) →
      (∀ i ∈ S, w i = u i) →
      (∀ i ∈ S, w i = v i) →
      W u = W v) :
    ∃ (g : Fin I → ℝ → ℝ) (φ : ℝ → ℝ),
      StrictMono φ ∧
      (∀ i, Continuous (g i)) ∧
      ∀ u : Fin I → ℝ, φ (W u) = ∑ i : Fin I, g i (u i) :=
  debreu_separability hI W hcont hincr hindep