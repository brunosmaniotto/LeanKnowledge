import Mathlib
open Topology

inductive WorkerType | L | H

structure SignalingModel where
  cost : WorkerType → ℝ → ℝ
  cost_nonneg : ∀ θ e, 0 ≤ cost θ e

theorem dominance_refinement_trivial (M : SignalingModel) (e : ℝ) (θ : WorkerType) :
    ∃ w : ℝ → ℝ, ∀ e' : ℝ, w e - M.cost θ e ≥ w e' - M.cost θ e' := by
  refine ⟨fun x => if x = e then M.cost θ e + 1 else 0, fun e' => ?_⟩
  by_cases h : e' = e
  · subst h; simp
  · simp [h]; linarith [M.cost_nonneg θ e']