import Mathlib

open Set

/-- The maximum utility agent `i` can attain in `U ∩ ℝᴵ₊` (the nonnegative part of `U`). -/
noncomputable def maxUtility {I : Type*} [Fintype I] (U : Set (I → ℝ)) (i : I) : ℝ :=
  sSup ((fun u => u i) '' (U ∩ {u | ∀ j, 0 ≤ u j}))

/-- An allocation `u` is Pareto optimal in `U` if no other allocation in `U`
    weakly dominates it with at least one strict improvement. -/
def isParetoOptimal {I : Type*} (U : Set (I → ℝ)) (u : I → ℝ) : Prop :=
  u ∈ U ∧ ¬∃ v ∈ U, (∀ i, u i ≤ v i) ∧ (∃ i, u i < v i)

/-- The Kalai-Smorodinsky bargaining solution assigns to every bargaining problem
    `U ⊂ ℝᴵ` the Pareto optimal allocation where utilities are proportional to
    the vector `(maxUtility U i)ᵢ`. That is, there exists `t ≥ 0` such that
    `u i = t * maxUtility U i` for all `i`, the point is in `U`, and it is
    Pareto optimal. -/
noncomputable def kalaiSmorodinskySolution {I : Type*} [Fintype I]
    (U : Set (I → ℝ)) : I → ℝ :=
  Classical.epsilon (fun u =>
    isParetoOptimal U u ∧
    ∃ t : ℝ, 0 ≤ t ∧ ∀ i, u i = t * maxUtility U i)