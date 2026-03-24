import Mathlib

open Finset
open BigOperators

variable {I : Type} [Fintype I] [DecidableEq I]
variable {X : Type} [Fintype X] [Nonempty X]
variable (T : I → Type)

-- Type profile: each agent i has a type in T i
def Profile : Type := ∀ i : I, T i

variable (v : ∀ i : I, X → Profile T → ℝ)

-- Total value of alternative x given type profile t
noncomputable def totalValue (x : X) (t : Profile T) : ℝ :=
  ∑ i ∈ univ, v i x t

-- Total value without agent i
noncomputable def totalValueWithout (i : I) (x : X) (t : Profile T) : ℝ :=
  ∑ j ∈ univ.erase i, v j x t

-- Efficient decision rule (maximizes total value)
variable (efficientDecision : Profile T → X)
variable (h_efficient : ∀ (t : Profile T) (x : X), totalValue T v x t ≤ totalValue T v (efficientDecision t) t)

-- Efficient decision without agent i
variable (efficientDecisionWithout : I → Profile T → X)
variable (h_efficient_without : ∀ (i : I) (t : Profile T) (x : X),
  totalValueWithout T v i x t ≤ totalValueWithout T v i (efficientDecisionWithout i t) t)

-- VCG transfer for agent i at profile t
noncomputable def vcgTransfer (i : I) (t : Profile T) : ℝ :=
  totalValueWithout T v i (efficientDecisionWithout i t) t -
  totalValueWithout T v i (efficientDecision t) t

-- Utility for agent i under profile t (quasilinear)
noncomputable def utility (i : I) (t : Profile T) : ℝ :=
  v i (efficientDecision t) t - vcgTransfer T v efficientDecision efficientDecisionWithout i t

-- Unilateral deviation: agent i reports t_i' instead of t_i