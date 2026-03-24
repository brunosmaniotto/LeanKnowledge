import Mathlib
open Topology

theorem exercise_7_16
    {S : Type*} [Fintype S] [DecidableEq S] [Nonempty S]
    (u : S → ℝ) :
    ∃ s : S, ∀ s' : S, u s' ≤ u s := by
  obtain ⟨s, _, hs⟩ := Finset.exists_max_image Finset.univ u Finset.univ_nonempty
  exact ⟨s, fun s' => hs s' (Finset.mem_univ _)⟩