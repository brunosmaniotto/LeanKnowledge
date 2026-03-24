import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- **Theorem 2.3** (Jehle & Reny): Duality between direct and indirect utility.
    If u is quasiconcave and differentiable with Du(x) ≫ 0 on ℝⁿ₊₊,
    then u(x) = min_{p ≫ 0} v(p, p · x) for all x ≫ 0.

    We abstract the two key ingredients:
    • hv_lb: x is always feasible in its own budget set, so v(p, p·x) ≥ u(x).
    • h_foc: setting p₀ = ∇u(x₀), the FOC are satisfied by quasiconcavity
      (Theorem 1.4), giving v(p₀, p₀·x₀) ≤ u(x₀). -/
theorem Theorem_2_3 {n : ℕ}
    (u : (Fin n → ℝ) → ℝ)
    (v : (Fin n → ℝ) → ℝ → ℝ)
    (x₀ : Fin n → ℝ) (hx₀ : ∀ i, 0 < x₀ i)
    (hv_lb : ∀ p : Fin n → ℝ, (∀ i, 0 < p i) →
      u x₀ ≤ v p (∑ i, p i * x₀ i))
    (h_foc : ∃ p₀ : Fin n → ℝ, (∀ i, 0 < p₀ i) ∧
      v p₀ (∑ i, p₀ i * x₀ i) ≤ u x₀) :
    ∃ p₀ : Fin n → ℝ, (∀ i, 0 < p₀ i) ∧
      v p₀ (∑ i, p₀ i * x₀ i) = u x₀ ∧
      ∀ p : Fin n → ℝ, (∀ i, 0 < p i) →
        v p₀ (∑ i, p₀ i * x₀ i) ≤ v p (∑ i, p i * x₀ i) := by
  obtain ⟨p₀, hp₀_pos, hp₀_le⟩ := h_foc
  have heq : v p₀ (∑ i, p₀ i * x₀ i) = u x₀ := le_antisymm hp₀_le (hv_lb p₀ hp₀_pos)
  exact ⟨p₀, hp₀_pos, heq, fun p hp => le_trans heq.le (hv_lb p hp)⟩