import Mathlib

open Set Topology
open Topology

/-- When u is continuous, v(p,y) is well-defined: the UMP has a solution
    because the budget set is compact and nonempty (Weierstrass). -/
theorem Claim_1_4_1_a
    {n : ℕ} {u : (Fin n → ℝ) → ℝ} {B : Set (Fin n → ℝ)}
    (hB_compact : IsCompact B)
    (hB_nonempty : B.Nonempty)
    (hu_cont : ContinuousOn u B) :
    ∃ x ∈ B, ∀ z ∈ B, u z ≤ u x := by
  obtain ⟨x, hxB, hmax⟩ := IsCompact.exists_isMaxOn hB_compact hB_nonempty hu_cont
  exact ⟨x, hxB, fun z hz => hmax hz⟩