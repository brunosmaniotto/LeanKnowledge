import Mathlib

open Finset BigOperators
open BigOperators

/-- If a common prior assigns positive probability to every joint type vector,
    then every type of every player receives positive marginal probability,
    so all players' conditional beliefs also assign positive probability. -/
theorem exercise_7_20_a {I : Type*} [Fintype I] [DecidableEq I]
    {Θ : I → Type*} [∀ i, Fintype (Θ i)] [∀ i, DecidableEq (Θ i)] [∀ i, Nonempty (Θ i)]
    (p : (∀ i, Θ i) → ℝ)
    (hp : ∀ θ, 0 < p θ)
    (i : I) (t_i : Θ i) :
    0 < ∑ θ ∈ Finset.univ.filter (fun θ : ∀ i, Θ i => θ i = t_i), p θ := by
  apply Finset.sum_pos
  · intro θ _; exact hp θ
  · exact ⟨Function.update (fun j => Classical.arbitrary (Θ j)) i t_i,
           Finset.mem_filter.mpr ⟨Finset.mem_univ _, Function.update_self i t_i _⟩⟩