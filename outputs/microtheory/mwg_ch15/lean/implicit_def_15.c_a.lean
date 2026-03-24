import Mathlib
open Topology

/-- A Robinson Crusoe economy with one consumer and one producer.
The consumer has an endowment of leisure L, owns the firm, and has preferences
over (leisure, consumption good). The firm converts labor into the consumption
good via production function f. -/
structure RobinsonCrusoeEconomy where
  /-- Units of leisure endowment -/
  L : ℝ
  L_pos : 0 < L
  /-- Production function: labor input → consumption good output -/
  f : ℝ → ℝ
  /-- f is increasing -/
  f_increasing : StrictMono f
  /-- f is strictly concave -/
  f_strictConcave : StrictConcaveOn ℝ (Set.Ici 0) f
  /-- Consumer's preference relation on (leisure, consumption good) bundles -/
  pref : ℝ × ℝ → ℝ × ℝ → Prop
  /-- Preferences are complete -/
  pref_complete : ∀ x y : ℝ × ℝ, pref x y ∨ pref y x
  /-- Preferences are transitive -/
  pref_trans : Transitive pref
  /-- Preferences are strongly monotone: strictly more of both goods is strictly preferred -/
  pref_stronglyMonotone : ∀ x y : ℝ × ℝ,
    x.1 ≤ y.1 → x.2 ≤ y.2 → (x.1 < y.1 ∨ x.2 < y.2) → pref y x ∧ ¬pref x y
  /-- Firm's profit function given price p and wage w -/
  profit (p w z : ℝ) : ℝ := p * f z - w * z