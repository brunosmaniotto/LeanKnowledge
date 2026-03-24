import Mathlib

open Set Filter Topology
open Topology

/--
If a preference is locally nonsatiated (for every point and every neighborhood,
there exists a strictly preferred point), then the consumption set cannot be
both closed and bounded (compact). Otherwise, continuity on a compact set
yields a global maximum, contradicting local nonsatiation.
-/
theorem consumption_set_unbounded_of_locally_nonsatiated
    {X : Set (EuclideanSpace ℝ (Fin n))}
    (hne : X.Nonempty)
    (hcpt : IsCompact X)
    {u : EuclideanSpace ℝ (Fin n) → ℝ}
    (hu_cont : ContinuousOn u X)
    (h_lns : ∀ x ∈ X, ∀ ε > (0 : ℝ), ∃ y ∈ X, dist y x < ε ∧ u x < u y) :
    False := by
  obtain ⟨x_max, hx_max_mem, hx_max⟩ := hcpt.exists_isMaxOn hne hu_cont
  obtain ⟨y, hy_mem, _, huy⟩ := h_lns x_max hx_max_mem 1 one_pos
  exact not_lt.mpr (hx_max hy_mem) huy