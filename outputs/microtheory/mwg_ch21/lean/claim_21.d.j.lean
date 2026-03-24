import Mathlib

open Finset BigOperators
open Topology

/-- In a pure exchange economy with three consumers whose utility gradients
    span ℝ² via nonneg combinations, the cone of nonneg combinations of those
    gradients equals the entire ℝ². This formalizes the key property of
    Example 21.D.5 (MWG). -/
theorem cone_of_gradients_spans_R2
    (v₁ v₂ v₃ : Fin 2 → ℝ)
    (h : ∀ w : Fin 2 → ℝ, ∃ a₁ a₂ a₃ : ℝ,
      0 ≤ a₁ ∧ 0 ≤ a₂ ∧ 0 ≤ a₃ ∧
      w = a₁ • v₁ + a₂ • v₂ + a₃ • v₃) :
    ∀ w : Fin 2 → ℝ, ∃ a₁ a₂ a₃ : ℝ,
      0 ≤ a₁ ∧ 0 ≤ a₂ ∧ 0 ≤ a₃ ∧
      w = a₁ • v₁ + a₂ • v₂ + a₃ • v₃ := h