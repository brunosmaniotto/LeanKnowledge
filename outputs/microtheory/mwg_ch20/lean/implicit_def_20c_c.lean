import Mathlib

/-- Standing assumptions on the production set Y for intertemporal production.
    Y ⊆ ℝ^(2L) satisfies: closed, convex, no free lunch, free disposal, truncation. -/
structure IntertempralProductionSet (L : ℕ) where
  /-- The production set Y ⊆ ℝ^(Fin (2*L)) -/
  Y : Set (Fin (2 * L) → ℝ)
  /-- Y is closed -/
  closed : IsClosed Y
  /-- Y is convex -/
  convex : Convex ℝ Y
  /-- No free lunch: Y ∩ ℝ₊^(2L) = {0} -/
  no_free_lunch : ∀ y ∈ Y, (∀ i, 0 ≤ y i) → y = 0
  /-- Free disposal: Y - ℝ₊^(2L) ⊆ Y -/
  free_disposal : ∀ y ∈ Y, ∀ z : Fin (2 * L) → ℝ, (∀ i, z i ≤ y i) → z ∈ Y
  /-- Possibility of truncation: if (y_b, y_a) ∈ Y then (y_b, 0) ∈ Y -/
  truncation : ∀ y ∈ Y,
    (fun i : Fin (2 * L) => if i.val < L then y i else 0) ∈ Y