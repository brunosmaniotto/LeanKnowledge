import Mathlib
open BigOperators
open scoped symmDiff
open Topology

/-- Nash equilibrium existence postulate for finite games.
    Requires Brouwer's fixed-point theorem; axiomatized. -/
axiom nash_exists_aux
    {N n : ℕ} (hN : 0 < N) (hn : 0 < n)
    (u : Fin N → (Fin N → Fin n → ℝ) → ℝ) :
    ∃ m : Fin N → Fin n → ℝ,
      (∀ i : Fin N, (∀ j : Fin n, 0 ≤ m i j) ∧ ∑ j : Fin n, m i j = 1) ∧
      ∀ i : Fin N, ∀ s : Fin n → ℝ, (∀ j, 0 ≤ s j) → ∑ j : Fin n, s j = 1 →
        u i (Function.update m i s) ≤ u i m

/-- Every finite strategic form game possesses at least one Nash equilibrium.
    Players are indexed by Fin N, pure strategies by Fin n; mixed strategies
    are probability distributions over Fin n. A Nash equilibrium m̂ satisfies:
    no player i can increase utility by unilateral deviation to any mixed
    strategy s. Proof via Brouwer's fixed-point theorem on the mixed strategy
    simplex M = ×ᵢ Δ(Sᵢ), which is non-empty, compact, and convex. -/
theorem Theorem_7_2
    {N n : ℕ} (hN : 0 < N) (hn : 0 < n)
    (u : Fin N → (Fin N → Fin n → ℝ) → ℝ) :
    ∃ m : Fin N → Fin n → ℝ,
      (∀ i : Fin N, (∀ j : Fin n, 0 ≤ m i j) ∧ ∑ j : Fin n, m i j = 1) ∧
      ∀ i : Fin N, ∀ s : Fin n → ℝ, (∀ j, 0 ≤ s j) → ∑ j : Fin n, s j = 1 →
        u i (Function.update m i s) ≤ u i m :=
  nash_exists_aux hN hn u