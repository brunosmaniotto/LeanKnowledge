import Mathlib

open MeasureTheory
open Topology

/-- Effort levels: low (eL) and high (eH). -/
inductive EffortLevel where
  | low  : EffortLevel
  | high : EffortLevel
  deriving DecidableEq

/-- Data for the optimal compensation problem. -/
structure CompensationProblem where
  v : ℝ → ℝ
  g : ℝ → ℝ
  f : ℝ → ℝ → ℝ
  u_bar : ℝ

/-- Map `EffortLevel` to the real-valued effort parameter used in `CompensationProblem`. -/
noncomputable def EffortLevel.toReal (g_val : EffortLevel → ℝ) : EffortLevel → ℝ := g_val

/-- Owner's surplus from effort level `e` under risk neutrality (v(w) = w):
    ∫ π f(π|e) dπ − g(e) − ū.
    When the manager is risk neutral the optimal wage is the constant
    w* = g(e) + ū, so the owner keeps expected profit minus that cost. -/
noncomputable def riskNeutralSurplus
    (P : CompensationProblem) (μ : Measure ℝ) (e : ℝ) : ℝ :=
  (∫ π, π * P.f π e ∂μ) - P.g e - P.u_bar

/-- Condition (14.B.6): When the manager is risk neutral (v(w) = w),
    the optimal effort level e* when effort is observable solves
      max_{e ∈ {e_L, e_H}} ∫ π f(π|e) dπ − g(e) − ū.
    The owner's profit equals this maximised value, and the manager
    receives expected utility exactly ū. -/
structure Condition_14B6 (P : CompensationProblem)
    (μ : Measure ℝ) (eL eH : ℝ) where
  /-- The manager is risk neutral: v(w) = w. -/
  risk_neutral : P.v = id
  /-- The optimal effort level (either eL or eH). -/
  eStar : ℝ
  /-- e* is one of the two effort levels. -/
  eStar_mem : eStar = eL ∨ eStar = eH
  /-- e* maximises surplus over {eL, eH}. -/
  eStar_optimal :
    riskNeutralSurplus P μ eStar ≥ riskNeutralSurplus P μ eL ∧
    riskNeutralSurplus P μ eStar ≥ riskNeutralSurplus P μ eH
  /-- The owner's profit equals the maximised surplus. -/
  owner_profit : ℝ
  owner_profit_eq : owner_profit = riskNeutralSurplus P μ eStar
  /-- The manager receives expected utility exactly ū. -/
  manager_utility_eq :
    (∫ π, P.v (P.g eStar + P.u_bar) * P.f π eStar ∂μ) - P.g eStar = P.u_bar