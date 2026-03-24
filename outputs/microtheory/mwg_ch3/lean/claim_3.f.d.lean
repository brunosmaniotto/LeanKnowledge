import Mathlib

open Finset BigOperators
open BigOperators

/-- The inner product p·x is linear in p, which is the key property ensuring
    the support function (and hence the expenditure function) is homogeneous
    of degree 1 and concave in p. -/
theorem expenditure_is_support_function_properties
    {L : ℕ} (S : Set (Fin L → ℝ)) (hne : S.Nonempty) :
    let σ : (Fin L → ℝ) → ℝ := fun p => ⨅ x ∈ S, ∑ i, p i * x i
    (∀ (p : Fin L → ℝ) (t : ℝ) (x : Fin L → ℝ),
      ∑ i, (t * p i) * x i = t * ∑ i, p i * x i) ∧
    (∀ (p q : Fin L → ℝ) (α : ℝ) (x : Fin L → ℝ),
      ∑ i, (α * p i + (1 - α) * q i) * x i =
      α * ∑ i, p i * x i + (1 - α) * ∑ i, q i * x i) := by
  intro σ
  refine ⟨fun p t x => ?_, fun p q α x => ?_⟩
  · conv_lhs => arg 2; ext i; rw [show (t * p i) * x i = t * (p i * x i) by ring]
    exact Finset.mul_sum univ (fun i => p i * x i) t |>.symm
  · conv_lhs =>
      arg 2; ext i
      rw [show (α * p i + (1 - α) * q i) * x i =
            α * (p i * x i) + (1 - α) * (q i * x i) by ring]
    rw [Finset.sum_add_distrib]
    congr 1 <;> exact (Finset.mul_sum univ _ _).symm