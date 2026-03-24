import Mathlib
open Topology
open Finset

/-- The strong axiom of revealed preference (SA) for a market demand function.
    x(p, w) satisfies SA if for any finite chain of price-wealth pairs where
    consecutive bundles differ and each is directly revealed preferred to the next,
    the last bundle cannot be directly revealed preferred to the first. -/
def SatisfiesStrongAxiomOfRevealedPreference
    {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ)) : Prop :=
  ∀ (N : ℕ) (hN : 0 < N)
    (p : Fin N → (Fin L → ℝ))
    (w : Fin N → ℝ),
    -- All consecutive bundles are distinct
    (∀ n : Fin (N - 1),
      x (p ⟨n.val + 1, by omega⟩) (w ⟨n.val + 1, by omega⟩) ≠
      x (p ⟨n.val, by omega⟩) (w ⟨n.val, by omega⟩)) →
    -- Each bundle is directly revealed preferred to the next
    (∀ n : Fin (N - 1),
      Finset.sum Finset.univ (fun l : Fin L =>
        p ⟨n.val, by omega⟩ l *
        x (p ⟨n.val + 1, by omega⟩) (w ⟨n.val + 1, by omega⟩) l) ≤
      w ⟨n.val, by omega⟩) →
    -- Then the last cannot be directly revealed preferred to the first
    Finset.sum Finset.univ (fun l : Fin L =>
      p ⟨N - 1, by omega⟩ l *
      x (p ⟨0, by omega⟩) (w ⟨0, by omega⟩) l) >
    w ⟨N - 1, by omega⟩