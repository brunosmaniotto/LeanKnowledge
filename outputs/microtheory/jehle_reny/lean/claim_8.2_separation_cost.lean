import Mathlib

open Filter Topology

theorem claim_8_2_separation_cost
    (separation_cost : ℝ)
    (pooling_cost : ℝ → ℝ)
    (π_l π_h : ℝ)
    (hπ : π_l < π_h)
    (h_sep : 0 < separation_cost)
    (h_pool_def : ∀ α, pooling_cost α = (1 - α) * (π_h - π_l))
    : (0 < separation_cost) ∧
      (Tendsto pooling_cost (nhds 1) (nhds 0)) := by
  constructor
  · exact h_sep
  · have key : Tendsto (fun x => (1 - x) * (π_h - π_l)) (nhds 1) (nhds 0) := by
      have : (fun x => (1 - x) * (π_h - π_l)) = fun x => (1 - x) * (π_h - π_l) := rfl
      rw [show (0 : ℝ) = (1 - 1) * (π_h - π_l) from by ring]
      exact (tendsto_const_nhds.sub tendsto_id).mul tendsto_const_nhds
    exact key.congr (fun x => (h_pool_def x).symm)