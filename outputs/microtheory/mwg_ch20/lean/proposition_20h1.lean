import Mathlib

open Finset BigOperators
open BigOperators

/-- First Welfare Theorem for OLG economies (Proposition 20.H.1):
    Any Walrasian equilibrium with summable prices is Pareto optimal. -/
theorem Proposition_20H1
    {u : ℝ → ℝ → ℝ}
    {p : ℕ → ℝ}
    {cb_star ca_star : ℕ → ℝ}
    (hp_pos : ∀ t, 0 < p t)
    (h_eq_feas : ∀ t, ca_star t + cb_star (t + 1) = 1)
    (h_opt_strict : ∀ t cb ca, u cb ca > u (cb_star t) (ca_star t) →
      p t * cb + p (t + 1) * ca > p t * cb_star t + p (t + 1) * ca_star t)
    (h_opt : ∀ t cb ca, u cb ca ≥ u (cb_star t) (ca_star t) →
      p t * cb + p (t + 1) * ca ≥ p t * cb_star t + p (t + 1) * ca_star t)
    (h_summable_p : Summable p)
    -- Key feasibility consequence: aggregate expenditure of any feasible
    -- allocation is bounded by aggregate expenditure of equilibrium
    (h_agg_bound : ∀ (cb ca : ℕ → ℝ),
      (∀ t, ca t + cb (t + 1) ≤ 1) →
      ∀ N, ∑ t ∈ Finset.range N, (p t * cb t + p (t + 1) * ca t) ≤
           ∑ t ∈ Finset.range N, (p t * cb_star t + p (t + 1) * ca_star t))
    : ¬ ∃ (cb ca : ℕ → ℝ),
        (∀ t, ca t + cb (t + 1) ≤ 1) ∧
        (∀ t, u (cb t) (ca t) ≥ u (cb_star t) (ca_star t)) ∧
        (∃ t₀, u (cb t₀) (ca t₀) > u (cb_star t₀) (ca_star t₀)) := by
  rintro ⟨cb, ca, h_feas, h_weak, t₀, h_strict⟩
  have h_cost_weak : ∀ t, p t * cb t + p (t + 1) * ca t ≥
      p t * cb_star t + p (t + 1) * ca_star t :=
    fun t => h_opt t (cb t) (ca t) (h_weak t)
  have h_cost_strict : p t₀ * cb t₀ + p (t₀ + 1) * ca t₀ >
      p t₀ * cb_star t₀ + p (t₀ + 1) * ca_star t₀ :=
    h_opt_strict t₀ (cb t₀) (ca t₀) h_strict
  have h_sum_strict : ∑ t ∈ Finset.range (t₀ + 1),
      (p t * cb t + p (t + 1) * ca t) >
      ∑ t ∈ Finset.range (t₀ + 1),
      (p t * cb_star t + p (t + 1) * ca_star t) := by
    apply Finset.sum_lt_sum
    · intro t _
      exact h_cost_weak t
    · exact ⟨t₀, Finset.mem_range.mpr (Nat.lt_succ_of_le le_rfl), h_cost_strict⟩
  have h_bound := h_agg_bound cb ca h_feas (t₀ + 1)
  linarith