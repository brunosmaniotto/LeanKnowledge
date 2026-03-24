import Mathlib

open Set

/-- A subset of ℝ is connected (in the subspace topology) if and only if it is nonempty and
    order-connected, i.e., an interval. -/
theorem isConnected_iff_ordConnected (S : Set ℝ) :
    IsConnected S ↔ S.Nonempty ∧ Set.OrdConnected S := by
  constructor
  · intro h
    exact ⟨h.nonempty, isPreconnected_iff_ordConnected.1 h.isPreconnected⟩
  · rintro ⟨hne, hord⟩
    exact ⟨hne, isPreconnected_iff_ordConnected.2 hord⟩