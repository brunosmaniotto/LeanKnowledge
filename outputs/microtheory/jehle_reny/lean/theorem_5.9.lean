import Mathlib

open Finset BigOperators Topology
open Topology
open BigOperators

noncomputable section

variable {n : ℕ}

/-- The profit function for firm j: π^j(p) = sup { p · y : y ∈ Y^j } -/
def firmProfit_5_9 (Yj : Set (Fin n → ℝ)) (p : Fin n → ℝ) : ℝ :=
  sSup ((fun y => ∑ l : Fin n, p l * y l) '' Yj)

/-- Theorem 5.9 (MWG): Under Assumption 5.2 conditions 1-3 (Y^j is closed, strictly convex,
    and satisfies free disposal), for p ≫ 0 the profit maximizer is unique and continuous,
    and the profit function is well-defined and continuous. -/
axiom Theorem_5_9
    (Yj : Set (Fin n → ℝ))
    (hClosed : IsClosed Yj)
    (hNonempty : Yj.Nonempty)
    (hStrictConvex : StrictConvex ℝ Yj)
    (hFreeDisposal : ∀ y ∈ Yj, ∀ y' : Fin n → ℝ, (∀ l : Fin n, y' l ≤ y l) → y' ∈ Yj) :
    ∃ (yj : (Fin n → ℝ) → (Fin n → ℝ)),
      (∀ p : Fin n → ℝ, (∀ l : Fin n, 0 < p l) →
        yj p ∈ Yj ∧
        (∀ y ∈ Yj, ∑ l : Fin n, p l * y l ≤ ∑ l : Fin n, p l * (yj p) l) ∧
        (∀ y ∈ Yj, (∑ l : Fin n, p l * y l = ∑ l : Fin n, p l * (yj p) l) → y = yj p)) ∧
      Continuous (fun p => firmProfit_5_9 Yj p)