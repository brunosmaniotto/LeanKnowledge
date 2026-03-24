import Mathlib
open Topology

/-- Two goods ℓ and k are substitutes at (p, u) if ∂hₗ(p,u)/∂pₖ > 0. -/
noncomputable def IsSubstitute
    (L : ℕ)
    (h : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) (u : ℝ) (ℓ k : Fin L) : Prop :=
  0 < deriv (fun pk => h (Function.update p k pk) u ℓ) (p k)

/-- Two goods ℓ and k are complements at (p, u) if ∂hₗ(p,u)/∂pₖ ≤ 0. -/
noncomputable def IsComplement
    (L : ℕ)
    (h : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) (u : ℝ) (ℓ k : Fin L) : Prop :=
  deriv (fun pk => h (Function.update p k pk) u ℓ) (p k) ≤ 0

/-- Two goods ℓ and k are gross substitutes at (p, w) if ∂xₗ(p,w)/∂pₖ > 0,
    where x is the Walrasian demand. -/
noncomputable def IsGrossSubstitute
    (L : ℕ)
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) (w : ℝ) (ℓ k : Fin L) : Prop :=
  0 < deriv (fun pk => x (Function.update p k pk) w ℓ) (p k)

/-- Two goods ℓ and k are gross complements at (p, w) if ∂xₗ(p,w)/∂pₖ ≤ 0,
    where x is the Walrasian demand. -/
noncomputable def IsGrossComplement
    (L : ℕ)
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) (w : ℝ) (ℓ k : Fin L) : Prop :=
  deriv (fun pk => x (Function.update p k pk) w ℓ) (p k) ≤ 0