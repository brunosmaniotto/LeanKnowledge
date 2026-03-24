import Mathlib

/-- A direct selling mechanism consists of an allocation rule p and a payment rule c,
    each mapping valuation profiles to per-player outcomes. -/
structure DirectMechanism (N : ℕ) where
  p : (Fin N → ℝ) → Fin N → ℝ
  c : (Fin N → ℝ) → Fin N → ℝ

open Classical in
/-- The direct mechanism equivalent to the first-price auction (Eq. 9.9).
    Player i wins (pᵢ = 1) iff vᵢ > vⱼ for all j ≠ i, and pays b̂(vᵢ);
    otherwise pᵢ = 0 and cᵢ = 0. -/
noncomputable def FPA_DirectMechanism {N : ℕ} (b_hat : ℝ → ℝ) : DirectMechanism N where
  p := fun v i => if ∀ j, j ≠ i → v i > v j then 1 else 0
  c := fun v i => if ∀ j, j ≠ i → v i > v j then b_hat (v i) else 0