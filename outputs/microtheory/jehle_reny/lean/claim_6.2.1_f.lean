import Mathlib
open Finset BigOperators
open Topology

/-- Order-invariance under continuous strictly increasing transformations.
    If W(u) > W(ũ), then W(ψ(u)) > W(ψ(ũ)) for any collection of
    continuous strictly increasing functions ψᵢ. -/
theorem Claim_6_2_1_f (N : ℕ) [NeZero N]
    (W : (Fin N → ℝ) → ℝ)
    (order_invariance : ∀ (ψ : Fin N → ℝ → ℝ),
      (∀ i, StrictMono (ψ i)) →
      ∀ (u ũ : Fin N → ℝ),
        W u > W ũ → W (fun i => ψ i (u i)) > W (fun i => ψ i (ũ i)))
    (ψ : Fin N → ℝ → ℝ)
    (hψ_mono : ∀ i, StrictMono (ψ i))
    (u ũ : Fin N → ℝ)
    (h : W u > W ũ) :
    W (fun i => ψ i (u i)) > W (fun i => ψ i (ũ i)) :=
  order_invariance ψ hψ_mono u ũ h