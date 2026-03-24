import Mathlib

open Topology

/-- A maximum of u(x) over the budget set B exists. This follows from the Weierstrass theorem
    because u is continuous and B is compact. -/
theorem Claim_1_3_c
    {n : ℕ} {B : Set (EuclideanSpace ℝ (Fin n))} {u : EuclideanSpace ℝ (Fin n) → ℝ}
    (hB_compact : IsCompact B) (hB_nonempty : B.Nonempty)
    (hu_cont : ContinuousOn u B) :
    ∃ x ∈ B, ∀ y ∈ B, u y ≤ u x := by
  obtain ⟨x, hxB, hmax⟩ := IsCompact.exists_isMaxOn hB_compact hB_nonempty hu_cont
  exact ⟨x, hxB, fun y hy => hmax hy⟩