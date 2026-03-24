import Mathlib

open Metric Set
open Topology

/-- Local Non-satiation (Axiom 4'). A strict preference relation `pref` on ℝⁿ₊ is
locally nonsatiated if for every `x₀ ∈ ℝⁿ₊` and every `ε > 0`, there exists
some `x ∈ Bε(x₀) ∩ ℝⁿ₊` such that `x ≻ x₀`. -/
def LocalNonSatiation {n : ℕ} (pref : (Fin n → ℝ) → (Fin n → ℝ) → Prop) : Prop :=
  ∀ x₀ : Fin n → ℝ, (∀ i, 0 ≤ x₀ i) →
    ∀ ε > 0, ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ dist x x₀ < ε ∧ pref x x₀