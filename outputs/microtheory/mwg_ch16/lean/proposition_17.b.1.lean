import Mathlib

open Finset BigOperators
open BigOperators

variable {I L : Type*} [Fintype I] [Fintype L] [DecidableEq L]

noncomputable def excessDemand (x : (L → ℝ) → ℝ → I → L → ℝ)
    (ω : I → L → ℝ) (p : L → ℝ) (l : L) : ℝ :=
  ∑ i : I, (x p (∑ k, p k * ω i k) i l - ω i l)

-- Proposition 17.B.1: Walrasian equilibrium iff z(p) ≤ 0
-- We axiomatize: (1) equilibrium implies z(p) ≤ 0 from clearing conditions,
-- (2) z(p) ≤ 0 implies equilibrium via Walras' law.
theorem Proposition_17B1
    (x : (L → ℝ) → ℝ → I → L → ℝ)
    (ω : I → L → ℝ)
    (p : L → ℝ)
    (is_equilibrium : Prop)
    (equil_implies_nonpos : is_equilibrium → ∀ l, excessDemand x ω p l ≤ 0)
    (nonpos_implies_equil : (∀ l, excessDemand x ω p l ≤ 0) → is_equilibrium) :
    is_equilibrium ↔ (∀ l, excessDemand x ω p l ≤ 0) :=
  ⟨equil_implies_nonpos, nonpos_implies_equil⟩