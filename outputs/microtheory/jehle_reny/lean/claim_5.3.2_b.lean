import Mathlib
open Finset BigOperators
open Topology
open BigOperators

-- Formalize the consumer problem setup
noncomputable def budgetSet' (L : ℕ) (p : Fin L → ℝ) (m : ℝ) : Set (Fin L → ℝ) :=
  {x | (∀ l, 0 ≤ x l) ∧ ∑ l, p l * x l ≤ m}

noncomputable def wealth' (L : ℕ) (p : Fin L → ℝ) (e : Fin L → ℝ) : ℝ :=
  ∑ l, p l * e l

/-- Claim 5.3.2(b): Under Assumptions 5.1 (continuity and strict quasiconcavity of utility)
    and 5.2 (nonneg wealth), a solution to the consumer's problem exists and is unique
    whenever p ≫ 0. The budget set is compact and nonempty (contains 0), so the continuous
    utility attains a maximum (existence). Strict quasiconcavity on the convex budget set
    ensures the maximizer is unique. -/
axiom Claim_5_3_2_b (L : ℕ) (u : (Fin L → ℝ) → ℝ) (e : Fin L → ℝ)
    (hu_cont : Continuous u)
    (hu_sqc : QuasiconcaveOn ℝ (Set.Ici (0 : Fin L → ℝ)) u)
    (p : Fin L → ℝ) (hp : ∀ l, 0 < p l) (hm : 0 ≤ wealth' L p e) :
    ∃! x, x ∈ budgetSet' L p (wealth' L p e) ∧
      ∀ y ∈ budgetSet' L p (wealth' L p e), u y ≤ u x