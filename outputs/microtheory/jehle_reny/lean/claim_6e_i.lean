import Mathlib

open Finset BigOperators Topology
open BigOperators

noncomputable def cesSWF_6ei {N : ℕ} (ρ : ℝ) (u : Fin N → ℝ) : ℝ :=
  (∑ i : Fin N, (u i) ^ ρ) ^ (1 / ρ)

def StronglySeparable {N : ℕ} (W : (Fin N → ℝ) → ℝ) : Prop :=
  ∀ i j : Fin N, i ≠ j →
    ∀ u v : Fin N → ℝ,
      (∀ k, k ≠ i → k ≠ j → u k = v k) →
      (W u ≤ W v ↔ W (Function.update (Function.update u i (v i)) j (v j)) ≤ W v)

axiom ces_representation {N : ℕ} (hN : 2 ≤ N)
    (W : (Fin N → ℝ) → ℝ)
    (hcont : Continuous W)
    (hhom : ∀ t : ℝ, 0 < t → ∀ u, W (fun i => t * u i) = t * W u)
    (hwp : ∀ u v : Fin N → ℝ, (∀ i, u i < v i) → W u < W v)
    (hanon : ∀ u (σ : Equiv.Perm (Fin N)), W (u ∘ σ) = W u)
    (hconv : ConvexOn ℝ Set.univ W)
    (hsep : StronglySeparable W) :
    ∃ ρ : ℝ, ρ ≠ 0 ∧ ρ < 1 ∧ ∀ u, W u = cesSWF_6ei ρ u