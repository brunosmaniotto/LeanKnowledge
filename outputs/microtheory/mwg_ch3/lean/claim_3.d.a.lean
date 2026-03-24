import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem claim_3Da
    {L : ℕ}
    (p : Fin L → ℝ)
    (w : ℝ)
    (xstar : Fin L → ℝ)
    (Du : Fin L → ℝ)
    (hp : ∀ ℓ, p ℓ > 0)
    (hx : ∀ ℓ, xstar ℓ ≥ 0)
    (hbudget : ∑ ℓ : Fin L, p ℓ * xstar ℓ ≤ w)
    (hKKT : ∃ lam : ℝ, lam ≥ 0 ∧
      (∀ ℓ, Du ℓ ≤ lam * p ℓ) ∧
      (∀ ℓ, xstar ℓ * (Du ℓ - lam * p ℓ) = 0)) :
    ∃ lam : ℝ, lam ≥ 0 ∧
      (∀ ℓ, Du ℓ ≤ lam * p ℓ) ∧
      (∀ ℓ, xstar ℓ > 0 → Du ℓ = lam * p ℓ) := by
  obtain ⟨lam, hlam_nn, hlam_ineq, hlam_compl⟩ := hKKT
  refine ⟨lam, hlam_nn, hlam_ineq, fun ℓ hpos => ?_⟩
  have hcs := hlam_compl ℓ
  have hxpos : xstar ℓ ≠ 0 := ne_of_gt hpos
  cases mul_eq_zero.mp hcs with
  | inl h => exact absurd h hxpos
  | inr h => linarith