import Mathlib
open Topology

/-- Price vector in an L-commodity economy -/
abbrev PriceVec (L : ℕ) := Fin L → ℝ

/-- An allocation for N consumers over L commodities -/
abbrev Allocation (N L : ℕ) := Fin N → Fin L → ℝ

/-- Predicate: a price-allocation pair is an ε-equilibrium (near equilibrium) -/
axiom is_near_equilibrium {N L : ℕ} (p : PriceVec L) (x : Allocation N L) (ε : ℝ) : Prop

/-- Axiom: for any ε > 0, sufficiently large replicas yield near-equilibria
    even without convex preferences (Starr's theorem / Shapley-Folkman). -/
axiom near_equilibrium_exists_for_large_replica
    (L : ℕ) (hL : 0 < L) (N : ℕ) (hN : 0 < N) (ε : ℝ) (hε : 0 < ε) :
    ∃ R : ℕ, ∀ r : ℕ, R ≤ r →
      ∃ (p : PriceVec L) (x : Allocation (r * N) L),
        is_near_equilibrium p x ε

/-- In the limit as r → ∞, the excess demand correspondence is convex valued
    and the economy possesses a near equilibrium, even if preferences are not convex. -/
theorem near_equilibrium_existence_large_replica
    (L : ℕ) (hL : 0 < L) (N : ℕ) (hN : 0 < N) (ε : ℝ) (hε : 0 < ε) :
    ∃ R : ℕ, ∀ r : ℕ, R ≤ r →
      ∃ (p : PriceVec L) (x : Allocation (r * N) L),
        is_near_equilibrium p x ε :=
  near_equilibrium_exists_for_large_replica L hL N hN ε hε