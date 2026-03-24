import Mathlib
open Topology

/-- Effort levels: low (eL) and high (eH). -/
inductive EffortLevel where
  | low  : EffortLevel
  | high : EffortLevel
deriving DecidableEq

/-- A manager's separable utility u(w, e) = v(w) - g(e), where v is strictly
    increasing and strictly concave in wages, and high effort has strictly
    greater disutility than low effort. -/
structure SeparableManagerUtility where
  /-- Utility from wages. -/
  v : ℝ → ℝ
  /-- Disutility of effort. -/
  g : EffortLevel → ℝ
  v_differentiable : Differentiable ℝ v
  /-- v'(w) > 0: strictly increasing in wages. -/
  v_strictMono : StrictMono v
  /-- v''(w) < 0: strictly concave in wages (strict risk aversion). -/
  v_strictConcave : StrictConcaveOn ℝ Set.univ v
  /-- g(eH) > g(eL): high effort is costlier. -/
  g_high_gt_low : g EffortLevel.high > g EffortLevel.low

/-- The composite utility function u(w, e) = v(w) - g(e). -/
noncomputable def SeparableManagerUtility.utility
    (u : SeparableManagerUtility) (w : ℝ) (e : EffortLevel) : ℝ :=
  u.v w - u.g e