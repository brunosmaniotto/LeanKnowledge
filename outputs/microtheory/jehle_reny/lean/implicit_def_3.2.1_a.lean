import Mathlib
open Topology

/-- Short-run production setup where some inputs are fixed and others are variable.
    'Returns to variable proportions' describes how output responds when variable
    inputs change while fixed inputs remain constant. -/
structure ShortRunProduction (n : ℕ) where
  /-- The production function mapping input vectors to output. -/
  f : (Fin n → ℝ) → ℝ
  /-- Which inputs are variable (true) vs fixed (false). -/
  isVariable : Fin n → Bool
  /-- At least one input is fixed (defining property of the short run). -/
  hasFixed : ∃ i, isVariable i = false
  /-- At least one input is variable (otherwise output cannot be varied). -/
  hasVariable : ∃ i, isVariable i = true
  /-- The fixed input levels. -/
  fixedLevel : Fin n → ℝ

/-- The short-run output function: variable inputs are chosen freely,
    fixed inputs are held at their fixed levels. -/
noncomputable def ShortRunProduction.output {n : ℕ} (sr : ShortRunProduction n) (v : Fin n → ℝ) : ℝ :=
  sr.f (fun i => if sr.isVariable i then v i else sr.fixedLevel i)