import Mathlib
open Topology

theorem effective_budget_set_approximation
    {X : Type*} [MetricSpace X]
    (p : X → ℝ)
    (hp : Continuous p)
    (x₀ : X)
    (x_perturbed : ℕ → X)
    (M : ℝ) (hM : M > 0)
    (h_insensitive : ∀ r : ℕ, 0 < r → dist (x_perturbed r) x₀ ≤ M / (r : ℝ))
    : ∀ ε > 0, ∃ R : ℕ, ∀ r : ℕ, R ≤ r →
      |p (x_perturbed r) - p x₀| < ε := by
  intro ε hε
  rw [Metric.continuous_iff] at hp
  obtain ⟨δ, hδ_pos, hδ⟩ := hp x₀ ε hε
  obtain ⟨R, hR⟩ := exists_nat_gt (M / δ)
  refine ⟨R + 1, fun r hr => ?_⟩
  have hr_pos : (0 : ℝ) < (r : ℝ) := Nat.cast_pos.mpr (by omega)
  have hRr : (R : ℝ) < (r : ℝ) := by exact_mod_cast show R < r by omega
  have hMRδ : M < ↑R * δ := by linarith [div_lt_iff₀ hδ_pos |>.mp hR]
  have hdist : dist (x_perturbed r) x₀ < δ := by
    calc dist (x_perturbed r) x₀ ≤ M / (r : ℝ) := h_insensitive r (by omega)
      _ < δ := by
          rw [div_lt_iff₀ hr_pos]
          nlinarith
  have := hδ (x_perturbed r) hdist
  rwa [Real.dist_eq] at this