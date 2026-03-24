import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The Vickrey-Clarke-Groves (VCG) mechanism: each agent reports a type,
    a social outcome is chosen, and each agent pays their externality. -/
structure VCGMechanism (I : ℕ) where
  /-- Type space for agents -/
  T : Type*
  /-- Outcome/social state space -/
  X : Type*
  /-- Agent valuations: v j x t_j is agent j's value for outcome x at type t_j -/
  v : Fin I → X → T → ℝ
  /-- Social choice function x̂(t): outcome chosen given reported type profile -/
  x_hat : (Fin I → T) → X
  /-- Without-i optimum x̃_i(t_{-i}): outcome maximizing others' welfare without agent i -/
  x_tilde : Fin I → (Fin I → T) → X

/-- VCG cost for agent i:
    c^VCG_i(t) = Σ_{j≠i} v_j(x̃_i(t_{-i}), t_j) − Σ_{j≠i} v_j(x̂(t), t_j)
    Each agent pays the externality they impose on others. -/
noncomputable def M.cost {I : ℕ} (m : VCGMechanism I)
    (i : Fin I) (t : Fin I → m.T) : ℝ :=
  ∑ j ∈ univ.filter (· ≠ i), m.v j (m.x_tilde i t) (t j) -
  ∑ j ∈ univ.filter (· ≠ i), m.v j (m.x_hat t) (t j)