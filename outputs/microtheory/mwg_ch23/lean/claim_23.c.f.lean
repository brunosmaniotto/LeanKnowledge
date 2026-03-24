import Mathlib
open BigOperators

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {K : Type*} [Nonempty K]
variable {Θ : Type*}

def ExPostEfficientProject (v : I → K → Θ → ℝ) (kf : (I → Θ) → K) : Prop :=
  ∀ (θ : I → Θ) (k' : K), ∑ i, v i k' (θ i) ≤ ∑ i, v i (kf θ) (θ i)