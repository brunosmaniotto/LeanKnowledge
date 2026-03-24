import Mathlib

open Finset BigOperators
open BigOperators

/-- A cooperative game on player set `I` assigns a real value to each coalition (subset of `I`). -/
abbrev CooperativeGame (I : Type*) := (Finset I → ℝ)

/-- A cooperative solution maps a cooperative game to a payoff vector (one real per player). -/
abbrev CooperativeSolution (I : Type*) := CooperativeGame I → (I → ℝ)

/-- A cooperative solution is independent of utility origins and of common changes of utility
    units if whenever `v(S) = β * v'(S) + ∑ i ∈ S, α i` for every coalition `S`, some
    per-player constants `α` and scalar `β > 0`, then `f(v) = β • f(v') + α`. -/
structure IndependentOfUtilityOriginsAndScale {I : Type*} [Fintype I] [DecidableEq I]
    (f : CooperativeSolution I) : Prop where
  invariance :
    ∀ (v v' : CooperativeGame I) (α : I → ℝ) (β : ℝ),
      0 < β →
      (∀ S : Finset I, v S = β * v' S + ∑ i ∈ S, α i) →
      ∀ i : I, f v i = β * f v' i + α i