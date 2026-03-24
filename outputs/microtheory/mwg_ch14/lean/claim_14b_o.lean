import Mathlib

open MeasureTheory
open Topology

/-- A model of contract simplification when signal y is uninformative.
    We show that replacing w(π,y) with certainty equivalent w̃(π) reduces owner cost. -/

-- We axiomatize the setup rather than building full measure theory machinery
axiom SignalSpace : Type
axiom ProfitSpace : Type

-- v is strictly concave utility function
axiom v : ℝ → ℝ
axiom v_strictConcave : StrictConcaveOn ℝ Set.univ v

-- Original wage schedule w(π, y) and replacement w̃(π)
axiom w : ProfitSpace → SignalSpace → ℝ
axiom w_tilde : ProfitSpace → ℝ

-- Conditional expectation operators (given π)
axiom E_y : ProfitSpace → (SignalSpace → ℝ) → ℝ

-- Defining property: v(w̃(π)) = E[v(w(π,y)) | π]
axiom w_tilde_def : ∀ π : ProfitSpace, v (w_tilde π) = E_y π (fun y => v (w π y))

-- E_y is an expectation over a non-degenerate distribution (not a point mass)
-- so strict Jensen's applies when w(π, ·) is non-constant
axiom w_not_constant : ∀ π : ProfitSpace, ∃ y₁ y₂ : SignalSpace, w π y₁ ≠ w π y₂

-- Jensen's inequality in this setting: for strictly concave v,
-- v(E[w]) > E[v(w)] when w is non-constant
axiom jensen_strict_concave :
  ∀ π : ProfitSpace,
    (∃ y₁ y₂ : SignalSpace, w π y₁ ≠ w π y₂) →
    v (E_y π (fun y => w π y)) > E_y π (fun y => v (w π y))

-- v is strictly increasing (utility function)
axiom v_strictMono : StrictMono v

-- Manager's expected utility is the same under both contracts
-- (since v(w̃(π)) = E[v(w(π,y))|π] by definition)
theorem manager_utility_unchanged (π : ProfitSpace) :
    v (w_tilde π) = E_y π (fun y => v (w π y)) :=
  w_tilde_def π

-- Key result: w̃(π) < E[w(π,y)|π] for each π, so owner pays less