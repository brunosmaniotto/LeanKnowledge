import Mathlib
open Topology

noncomputable section

variable {I : Type*} [DecidableEq I]

/-- Revelation Principle for selling mechanisms:
    Given an equilibrium strategy σ mapping values to bids, the direct mechanism
    (where bidders report values and the designer applies σ) is incentive-compatible. -/
theorem revelation_principle_selling
    (prob cost : (I → ℝ) → I → ℝ)
    (σ : ℝ → ℝ)
    (equil : ∀ (i : I) (vals : I → ℝ) (s' : ℝ),
      vals i * prob (σ ∘ vals) i - cost (σ ∘ vals) i ≥
      vals i * prob (Function.update (σ ∘ vals) i s') i -
        cost (Function.update (σ ∘ vals) i s') i)
    (i : I) (vals : I → ℝ) (v' : ℝ) :
    vals i * prob (σ ∘ vals) i - cost (σ ∘ vals) i ≥
    vals i * prob (σ ∘ Function.update vals i v') i -
      cost (σ ∘ Function.update vals i v') i := by
  have key : σ ∘ Function.update vals i v' = Function.update (σ ∘ vals) i (σ v') := by
    funext j
    simp only [Function.comp_apply, Function.update_apply]
    split_ifs <;> rfl
  rw [key]
  exact equil i vals (σ v')