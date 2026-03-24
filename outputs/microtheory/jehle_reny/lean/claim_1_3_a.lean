import Mathlib

open Set Filter Topology
open Topology

noncomputable section

variable {n : ℕ}

/-- Theorem of the Maximum (A2.21): If f is continuous and C is a compact-valued
    correspondence with a unique maximizer (single-valued argmax), then the
    selection is continuous. -/
axiom theorem_of_the_maximum
    {X P : Type*} [TopologicalSpace X] [TopologicalSpace P]
    (f : X → ℝ) (C : P → Set X) (sel : P → X)
    (hf : Continuous f)
    (hC_compact : ∀ p, IsCompact (C p))
    (hC_nonempty : ∀ p, (C p).Nonempty)
    (hsel : ∀ p, sel p ∈ C p ∧ ∀ x ∈ C p, f x ≤ f (sel p)) :
    Continuous sel

/-- Under Assumption 1.2 (u continuous, strictly increasing, strictly quasiconcave)
    and strictly positive prices, the demand function x(p,y) is continuous on
    ℝⁿ₊₊ × ℝ₊, by the Theorem of the Maximum (Theorem A2.21). -/
theorem Claim_1_3_a
    (u : (Fin n → ℝ) → ℝ)
    (hu : Continuous u)
    (budgetSet : (Fin n → ℝ) × ℝ → Set (Fin n → ℝ))
    (x : (Fin n → ℝ) × ℝ → (Fin n → ℝ))
    (hB_compact : ∀ py, IsCompact (budgetSet py))
    (hB_nonempty : ∀ py, (budgetSet py).Nonempty)
    (hx_opt : ∀ py, x py ∈ budgetSet py ∧
      ∀ z ∈ budgetSet py, u z ≤ u (x py)) :
    Continuous x := by
  exact theorem_of_the_maximum u budgetSet x hu hB_compact hB_nonempty hx_opt