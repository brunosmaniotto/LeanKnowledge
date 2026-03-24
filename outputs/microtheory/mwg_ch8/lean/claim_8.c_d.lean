import Mathlib

open Set
open Topology

/-- A strictly dominated strategy is never a best response. Therefore, at each
    stage of iterative elimination, the survivors under "remove never-best-responses"
    (rationalizability) form a subset of the survivors under "remove strictly dominated"
    (IESDS). By induction the final rationalizable set is no larger than the IESDS set. -/
theorem rationalizable_subset_iesds
    {α : Type*} (S : Set α)
    (step_rat step_iesds : Set α → Set α)
    (h_mono_rat : Monotone step_rat)
    (h_mono_iesds : Monotone step_iesds)
    (h_step : ∀ T, step_rat T ⊆ step_iesds T)
    (n : ℕ) :
    (step_rat^[n]) S ⊆ (step_iesds^[n]) S := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp only [Function.iterate_succ', Function.comp]
    calc step_rat ((step_rat^[n]) S)
        ⊆ step_rat ((step_iesds^[n]) S) := h_mono_rat ih
      _ ⊆ step_iesds ((step_iesds^[n]) S) := h_step _