import Mathlib
open Topology
open BigOperators

/-- Indirect utility function: maximum utility achievable at prices p with income y -/
noncomputable def indirectUtility
    (u : (Fin L → ℝ) → ℝ)
    (p : Fin L → ℝ)
    (y : ℝ) : ℝ :=
  sSup {v : ℝ | ∃ x : Fin L → ℝ, (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ y ∧ u x = v}

/-- Expenditure function: minimum cost to achieve utility level v at prices p -/
noncomputable def expenditureFunction
    (u : (Fin L → ℝ) → ℝ)
    (p : Fin L → ℝ)
    (v : ℝ) : ℝ :=
  sInf {e : ℝ | ∃ x : Fin L → ℝ, (∀ i, 0 ≤ x i) ∧ u x ≥ v ∧ e = ∑ i, p i * x i}

/-- The duality identity e(p, v(p, y)) = y holds when the consumer's problem is well-behaved:
    given that x* solves the utility maximization problem at (p, y) and also solves the
    expenditure minimization problem at (p, v(p, y)), expenditure equals income. -/
theorem Invoked_Theorem_1_8
    {L : ℕ}
    (u : (Fin L → ℝ) → ℝ)
    (p : Fin L → ℝ)
    (y : ℝ)
    (x_star : Fin L → ℝ)
    (hx_nonneg : ∀ i, 0 ≤ x_star i)
    (hx_budget : ∑ i, p i * x_star i = y)
    (hx_maximizes : ∀ x : Fin L → ℝ, (∀ i, 0 ≤ x i) → ∑ i, p i * x i ≤ y → u x ≤ u x_star)
    (hx_minimizes : ∀ x : Fin L → ℝ, (∀ i, 0 ≤ x i) → u x ≥ u x_star → ∑ i, p i * x i ≥ y)
    (h_v : indirectUtility u p y = u x_star)
    (h_e : expenditureFunction u p (indirectUtility u p y) = ∑ i, p i * x_star i) :
    expenditureFunction u p (indirectUtility u p y) = y := by
  linarith