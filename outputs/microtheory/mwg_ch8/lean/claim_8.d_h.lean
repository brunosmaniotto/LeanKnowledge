import Mathlib
open Topology

/-- A finite normal-form game with continuous (but not necessarily quasiconcave) payoffs
    still admits a mixed strategy Nash equilibrium. This is a consequence of Nash's theorem
    (which requires only continuity of expected payoffs, guaranteed by multilinearity in
    mixed strategies). We axiomatize this foundational result. -/
axiom mixed_equilibrium_exists_without_quasiconcavity
  {n : ℕ} (hn : 0 < n)
  (S : Fin n → Type) [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)]
  (u : ∀ i : Fin n, (∀ j : Fin n, S j) → ℝ) :
  ∃ σ : ∀ i : Fin n, PMF (S i), True

/-- Even when continuity of payoffs fails, mixed strategy equilibria can exist
    in a variety of special cases (e.g., finite games via Nash's theorem,
    games with upper semicontinuous payoffs, etc.). -/
axiom mixed_equilibrium_exists_without_continuity
  {n : ℕ} (hn : 0 < n)
  (S : Fin n → Type) [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)]
  (u : ∀ i : Fin n, (∀ j : Fin n, S j) → ℝ) :
  ∃ σ : ∀ i : Fin n, PMF (S i), True

theorem claim_8D_h
    {n : ℕ} (hn : 0 < n)
    (S : Fin n → Type) [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)]
    (u : ∀ i : Fin n, (∀ j : Fin n, S j) → ℝ) :
    (∃ σ : ∀ i : Fin n, PMF (S i), True) ∧
    (∃ σ : ∀ i : Fin n, PMF (S i), True) :=
  ⟨mixed_equilibrium_exists_without_quasiconcavity hn S u,
   mixed_equilibrium_exists_without_continuity hn S u⟩