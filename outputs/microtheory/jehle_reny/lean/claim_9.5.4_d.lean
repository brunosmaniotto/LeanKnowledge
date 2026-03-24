import Mathlib
open BigOperators Finset
open Topology

/-- VCG voluntary participation: each agent weakly prefers to participate. -/
theorem vcg_voluntary_participation
    {N : ℕ} [NeZero N]
    {X : Type*}
    (v : Fin N → X → ℝ)          -- v_i(x, t_i): agent i's valuation
    (x_hat : X)                    -- x̂(t): social choice maximizing total welfare
    (x_tilde : Fin N → X)         -- x̃_i(t_{-i}): outcome without agent i
    -- x̂ maximizes total welfare: for any alternative y, Σ v_j(x̂) ≥ Σ v_j(y)
    (h_max : ∀ y : X, ∑ j : Fin N, v j x_hat ≥ ∑ j : Fin N, v j y)
    -- VCG cost for agent i: c_i = Σ_{j≠i} v_j(x̃_i) - Σ_{j≠i} v_j(x̂)
    (vcg_cost : Fin N → ℝ)
    (h_cost : ∀ i : Fin N, vcg_cost i =
      ∑ j ∈ univ.filter (· ≠ i), v j (x_tilde i) -
      ∑ j ∈ univ.filter (· ≠ i), v j x_hat)
    (i : Fin N) :
    v i x_hat - vcg_cost i ≥ v i (x_tilde i) := by
  rw [h_cost i]
  -- Goal: v i x_hat - (Σ_{j≠i} v_j(x̃_i) - Σ_{j≠i} v_j(x̂)) ≥ v i(x̃_i)
  -- Equivalently: Σ_j v_j(x̂) - Σ_{j≠i} v_j(x̃_i) ≥ v i(x̃_i)
  have key := h_max (x_tilde i)
  -- Σ_j v_j(x̂) = v_i(x̂) + Σ_{j≠i} v_j(x̂)
  have split_hat : ∑ j : Fin N, v j x_hat =
      v i x_hat + ∑ j ∈ univ.filter (· ≠ i), v j x_hat := by
    rw [← Finset.add_sum_erase _ _ (mem_univ i)]
    congr 1
    apply sum_congr
    · ext x; simp [Finset.mem_erase, Finset.mem_filter]
    · intros; rfl
  have split_tilde : ∑ j : Fin N, v j (x_tilde i) =
      v i (x_tilde i) + ∑ j ∈ univ.filter (· ≠ i), v j (x_tilde i) := by
    rw [← Finset.add_sum_erase _ _ (mem_univ i)]
    congr 1
    apply sum_congr
    · ext x; simp [Finset.mem_erase, Finset.mem_filter]
    · intros; rfl
  linarith