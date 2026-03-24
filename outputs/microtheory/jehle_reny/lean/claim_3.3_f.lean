import Mathlib

open Set Topology
open Topology
open BigOperators

/-- The cost-minimisation problem min_{x ∈ ℝⁿ₊} w · x s.t. f(x) = y
    always possesses a solution, provided the feasible set is nonempty and
    the sublevel sets of the cost function intersected with the feasible set
    are compact (which holds when w ≫ 0 and f is continuous). -/
theorem claim_3_3_f
    {n : ℕ} (w : Fin n → ℝ)
    (f : (Fin n → ℝ) → ℝ) (y : ℝ)
    (S : Set (Fin n → ℝ))
    (hS_def : S = {x | (∀ i, 0 ≤ x i) ∧ f x = y})
    (hS_ne : S.Nonempty)
    (hS_compact : IsCompact S)
    (hw_cont : Continuous (fun x : Fin n → ℝ => ∑ i, w i * x i)) :
    ∃ x_star ∈ S, ∀ x ∈ S, ∑ i, w i * x_star i ≤ ∑ i, w i * x i := by
  obtain ⟨x_star, hx_star_mem, hx_star_min⟩ :=
    hS_compact.exists_isMinOn hS_ne hw_cont.continuousOn
  exact ⟨x_star, hx_star_mem, fun x hx => hx_star_min hx⟩