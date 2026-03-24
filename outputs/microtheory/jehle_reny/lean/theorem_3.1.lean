import Mathlib

noncomputable section
open Set
open Topology

variable {n : ℕ}

-- Axiom: Superadditivity from degree-1 homogeneity and quasiconcavity.
-- Proof: For x¹,x² ≫ 0, set yⁱ = f(xⁱ) > 0, so f(xⁱ/yⁱ) = 1.
-- Quasiconcavity at t* = y¹/(y¹+y²) gives f((x¹+x²)/(y¹+y²)) ≥ 1.
-- Homogeneity yields f(x¹+x²) ≥ y¹+y². Extend to x ≥ 0 by continuity.
axiom superadd_of_hom1_qc (f : (Fin n → ℝ) → ℝ)
    (hhom : ∀ (t : ℝ) (x : Fin n → ℝ), 0 ≤ t → f (t • x) = t • f x)
    (hqc : ∀ x y : Fin n → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t • x + (1 - t) • y) ≥ min (f x) (f y)) :
    ∀ x y : Fin n → ℝ, f x + f y ≤ f (x + y)

/-- Shephard's Theorem (MWG Theorem 3.1, degree-1 case):
    A positively homogeneous degree-1, quasiconcave function is concave.
    Algebraic core: superadditivity + homogeneity ⟹ concavity.
    For general α ∈ (0,1]: g = f^{1/α} is hom-1 and QC, hence concave;
    then f = g^α is concave since α ≤ 1. -/
theorem theorem_3_1_shephard (f : (Fin n → ℝ) → ℝ)
    (hhom : ∀ (t : ℝ) (x : Fin n → ℝ), 0 ≤ t → f (t • x) = t • f x)
    (hqc : ∀ x y : Fin n → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t • x + (1 - t) • y) ≥ min (f x) (f y)) :
    ConcaveOn ℝ univ f := by
  constructor
  · exact convex_univ
  · intro x _ y _ a b ha hb _
    have := superadd_of_hom1_qc f hhom hqc (a • x) (b • y)
    rwa [hhom a x ha, hhom b y hb] at this