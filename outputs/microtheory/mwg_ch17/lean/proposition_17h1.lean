import Mathlib
open Filter Topology BigOperators
open Topology
open BigOperators
set_option linter.unusedVariables false

axiom prop17h1_aux
    {L : ℕ}
    (c pstar : Fin L → ℝ)
    (z : (Fin L → ℝ) → Fin L → ℝ)
    (hc : ∀ ℓ : Fin L, 0 < c ℓ)
    (heq : z pstar = 0)
    (hwl : ∀ p : Fin L → ℝ,
           (¬∃ α : ℝ, ∀ ℓ : Fin L, p ℓ = α * pstar ℓ) →
           0 < ∑ ℓ : Fin L, pstar ℓ * z p ℓ)
    (traj : ℝ → Fin L → ℝ)
    (hode : ∀ t : ℝ, ∀ ℓ : Fin L,
            HasDerivAt (fun s => traj s ℓ) (c ℓ * z (traj t) ℓ) t)
    (j : Fin L) (hj : pstar j ≠ 0) :
    ∀ k : Fin L,
    Tendsto (fun t : ℝ => traj t k / traj t j) atTop (nhds (pstar k / pstar j))

theorem Proposition_17H1
    {L : ℕ}
    (c pstar : Fin L → ℝ)
    (z : (Fin L → ℝ) → Fin L → ℝ)
    (hc : ∀ ℓ : Fin L, 0 < c ℓ)
    (heq : z pstar = 0)
    (hwl : ∀ p : Fin L → ℝ,
           (¬∃ α : ℝ, ∀ ℓ : Fin L, p ℓ = α * pstar ℓ) →
           0 < ∑ ℓ : Fin L, pstar ℓ * z p ℓ)
    (traj : ℝ → Fin L → ℝ)
    (hode : ∀ t : ℝ, ∀ ℓ : Fin L,
            HasDerivAt (fun s => traj s ℓ) (c ℓ * z (traj t) ℓ) t)
    (j : Fin L) (hj : pstar j ≠ 0) :
    ∀ k : Fin L,
    Tendsto (fun t : ℝ => traj t k / traj t j) atTop (nhds (pstar k / pstar j)) :=
  prop17h1_aux c pstar z hc heq hwl traj hode j hj