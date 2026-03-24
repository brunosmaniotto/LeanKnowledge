import Mathlib

open Finset BigOperators
open BigOperators

/-- Under a full-support common prior, every type of every other player
    is assigned positive conditional probability. -/
theorem exercise_7_20_a
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θ : I → Type*} [∀ i, Fintype (Θ i)] [∀ i, DecidableEq (Θ i)] [∀ i, Nonempty (Θ i)]
    (p : (∀ i, Θ i) → ℝ)
    (hp : ∀ θ, 0 < p θ)
    {i j : I} (hij : i ≠ j) (t_i : Θ i) (θ_j : Θ j) :
    0 < ∑ θ ∈ univ.filter (fun θ : ∀ k, Θ k => θ i = t_i ∧ θ j = θ_j), p θ := by
  apply Finset.sum_pos (fun x _ => hp x)
  refine ⟨Function.update (Function.update (fun k => Classical.arbitrary (Θ k)) i t_i) j θ_j,
          mem_filter.mpr ⟨mem_univ _, ?_, ?_⟩⟩
  · simp [hij]
  · simp