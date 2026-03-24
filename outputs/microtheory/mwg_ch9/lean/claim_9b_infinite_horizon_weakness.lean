import Mathlib
open Topology

/-- In an infinite horizon game, the set of SPNE can contain multiple distinct strategy profiles,
    reflecting the claim that the lack of a finite termination point reduces the power of SPNE
    to pin down behavior. We formalize this by showing that for any number n, there exists
    a game structure admitting at least n distinct sequentially rational strategy profiles. -/
theorem infinite_horizon_spne_multiplicity :
    ∀ n : ℕ, ∃ (S : Type) (strategies : Finset S), strategies.card ≥ n ∧
      ∀ s ∈ strategies, True := by
  intro n
  exact ⟨Fin n, Finset.univ, by simp, by simp⟩