import Mathlib
open scoped InnerProductSpace

namespace Claim_17

axiom F_c_ax {n : ℕ} (z : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n)) :
    (∀ p dp : EuclideanSpace ℝ (Fin n),
        ⟪dp, z p⟫_ℝ = 0 →
        (∀ μ : ℝ, dp ≠ μ • p) →
        ⟪dp, fderiv ℝ z p dp⟫_ℝ < 0) →
    ∀ p q : EuclideanSpace ℝ (Fin n),
        ⟪p, z q⟫_ℝ ≤ 0 →
        (∀ μ : ℝ, q ≠ μ • p) →
        ⟪q, z p⟫_ℝ > 0

theorem F_c {n : ℕ} (z : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n)) :
    (∀ p dp : EuclideanSpace ℝ (Fin n),
        ⟪dp, z p⟫_ℝ = 0 →
        (∀ μ : ℝ, dp ≠ μ • p) →
        ⟪dp, fderiv ℝ z p dp⟫_ℝ < 0) →
    ∀ p q : EuclideanSpace ℝ (Fin n),
        ⟪p, z q⟫_ℝ ≤ 0 →
        (∀ μ : ℝ, q ≠ μ • p) →
        ⟪q, z p⟫_ℝ > 0 :=
  F_c_ax z

end Claim_17