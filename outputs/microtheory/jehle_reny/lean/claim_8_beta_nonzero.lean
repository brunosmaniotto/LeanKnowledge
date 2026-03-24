import Mathlib

open BigOperators
open Topology

/-- In the optimal high-effort policy under moral hazard (MWG §8),
    the multiplier β on the incentive-compatibility constraint is nonzero.
    If β = 0, the FOC (8.22) forces constant utility across loss states,
    which violates the IC constraint (8.21) when high effort is costlier. -/
theorem claim_8_beta_nonzero
    {n : ℕ} (hn : 0 < n)
    (π₀ π₁ : Fin n → ℝ)
    (hπ₀_sum : ∑ l : Fin n, π₀ l = 1)
    (hπ₁_sum : ∑ l : Fin n, π₁ l = 1)
    (d₀ d₁ : ℝ)
    (hd : d₀ < d₁)
    (v : Fin n → ℝ)
    (hIC : (∑ l : Fin n, π₁ l * v l) - d₁ ≥ (∑ l : Fin n, π₀ l * v l) - d₀)
    (β : ℝ)
    (h_foc : β = 0 → ∀ l : Fin n, v l = v ⟨0, hn⟩)
    : β ≠ 0 := by
  intro hβ
  have hc := h_foc hβ
  have key : ∀ (π : Fin n → ℝ), (∑ l : Fin n, π l) = 1 →
      (∑ l : Fin n, π l * v l) = v ⟨0, hn⟩ := by
    intro π hπ
    have h1 : ∑ l : Fin n, π l * v l = ∑ l : Fin n, π l * v ⟨0, hn⟩ :=
      Finset.sum_congr rfl fun l _ => by rw [hc l]
    rw [h1, ← Finset.sum_mul, hπ, one_mul]
  linarith [key π₁ hπ₁_sum, key π₀ hπ₀_sum]