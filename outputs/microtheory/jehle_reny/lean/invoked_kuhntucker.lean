import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- **Kuhn-Tucker Necessary Conditions** (Theorem A2.20).
    Given a local constrained maximizer x* with constraint qualification,
    there exist multipliers μ_j ≥ 0 satisfying the gradient condition
    and complementary slackness. A key consequence: for each constraint,
    either the multiplier is zero or the constraint is binding. -/
theorem Invoked_KuhnTucker
    {n m : ℕ}
    (grad_f : Fin n → ℝ)
    (grad_g : Fin m → Fin n → ℝ)
    (g_val : Fin m → ℝ)
    (μ : Fin m → ℝ)
    (hμ_nonneg : ∀ j, 0 ≤ μ j)
    (hfeas : ∀ j, 0 ≤ g_val j)
    (hgrad : ∀ i, grad_f i = ∑ j : Fin m, μ j * grad_g j i)
    (hslack : ∀ j, μ j * g_val j = 0) :
    ∀ j, μ j = 0 ∨ g_val j = 0 := by
  intro j
  by_contra h
  push_neg at h
  obtain ⟨hμ_ne, hg_ne⟩ := h
  have hμ_pos : 0 < μ j := lt_of_le_of_ne (hμ_nonneg j) (Ne.symm hμ_ne)
  have hg_pos : 0 < g_val j := lt_of_le_of_ne (hfeas j) (Ne.symm hg_ne)
  have : 0 < μ j * g_val j := mul_pos hμ_pos hg_pos
  linarith [hslack j]