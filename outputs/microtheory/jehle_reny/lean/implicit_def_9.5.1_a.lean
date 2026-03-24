import Mathlib
open Topology

/-- Quasi-linear preferences with private values (MWG 9.5.1).
    Each agent i has a type space `T i` and a dollar-valued function
    `v i x t_i`.  Utility from social state `x` with money `m` and
    type `t_i` is `v i x t_i + m`.  Private values: `v` depends only
    on the agent's own type, not on others' types. -/
structure QuasiLinearPreferences (I : Type*) (X : Type*) where
  /-- Type space for each agent -/
  T : I → Type*
  /-- Dollar valuation: agent i's value for social state x given own type t_i -/
  v : (i : I) → X → T i → ℝ

/-- The von Neumann–Morgenstern utility under quasi-linear preferences:
    u_i(x, t_i, m) = v_i(x, t_i) + m -/
noncomputable def QuasiLinearPreferences.utility
    {I : Type*} {X : Type*} (ql : QuasiLinearPreferences I X)
    (i : I) (x : X) (t_i : ql.T i) (m : ℝ) : ℝ :=
  ql.v i x t_i + m