import Mathlib

open Finset

/-- The Leontief input-output model is a special case of the linear activity model
    with two additional features:
    (i) The Lth commodity (primary factor, e.g. labor) is not produced by any activity.
    (ii) Every elementary activity has at most a single positive output (no joint production). -/
structure LeontiefModel (L : ℕ) (J : ℕ) where
  /-- The activity matrix: each column j is an elementary activity vector in ℝ^(L+1),
      where the first L commodities are produced goods and index L is the primary factor -/
  A : Fin J → Fin (L + 1) → ℝ
  /-- The last commodity (index L) is the primary factor: no activity produces it,
      i.e., for every activity j, the entry for the primary factor is nonpositive -/
  primaryFactorNotProduced : ∀ j : Fin J, A j (Fin.last L) ≤ 0
  /-- No joint production: each elementary activity has at most one strictly positive entry -/
  noJointProduction : ∀ j : Fin J,
    ∀ i₁ i₂ : Fin (L + 1), A j i₁ > 0 → A j i₂ > 0 → i₁ = i₂