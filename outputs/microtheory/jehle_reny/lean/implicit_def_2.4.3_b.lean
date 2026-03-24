import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A simple gamble over `n` outcomes: probabilities `p` and wealth levels `w`. -/
structure SimpleGamble (n : ℕ) where
  p : Fin n → ℝ
  w : Fin n → ℝ

/-- The expected value of a simple gamble: E(g) = Σᵢ pᵢ wᵢ. -/
noncomputable def P.expectedValue {n : ℕ} (g : SimpleGamble n) : ℝ :=
  ∑ i : Fin n, g.p i * g.w i

/-- The VNM utility of a simple gamble given a utility function u:
    u(g) = Σᵢ pᵢ u(wᵢ). -/
noncomputable def SimpleGamble.vnmUtility {n : ℕ} (u : ℝ → ℝ) (g : SimpleGamble n) : ℝ :=
  ∑ i : Fin n, g.p i * u (g.w i)