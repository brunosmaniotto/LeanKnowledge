import Mathlib
open Topology

section MKf

variable {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
variable (S : Set (EuclideanSpace ℝ (Fin n)))

/-- Minimizing f over S is equivalent to maximizing -f over S,
    so KKT multipliers for inequality constraints flip sign (≥0 becomes ≤0). -/
theorem claim_MK_f (x : EuclideanSpace ℝ (Fin n)) :
    (∀ y ∈ S, f x ≤ f y) ↔ (∀ y ∈ S, (-f) y ≤ (-f) x) := by
  simp only [Pi.neg_apply, neg_le_neg_iff]

end MKf