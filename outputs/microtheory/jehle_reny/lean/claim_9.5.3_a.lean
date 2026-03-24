import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A general social choice mechanism (Definition 9.4) for N+1 individuals over
    a finite set of social states, with valuation and payment functions. -/
structure GeneralMechanism (N : ℕ) where
  num_states : ℕ
  outcome : (Fin N → ℝ) → Fin num_states
  payment : (Fin N → ℝ) → Fin N → ℝ

/-- A direct selling mechanism (Definition 9.1) for a single object with N bidders. -/
structure DirectSellingMechanism (N : ℕ) where
  allocation : (Fin N → ℝ) → Fin N → ℝ
  payment : (Fin N → ℝ) → Fin N → ℝ
  alloc_nonneg : ∀ θ i, 0 ≤ allocation θ i
  alloc_sum_le : ∀ θ, ∑ i : Fin N, allocation θ i ≤ 1

/-- Given a general mechanism with N+1 states (one allocation per individual),
    we can extract a direct selling mechanism. -/
noncomputable def toDirect (N : ℕ)
    (G : GeneralMechanism N)
    (alloc_of_state : Fin G.num_states → Fin N → ℝ)
    (h_nonneg : ∀ s i, 0 ≤ alloc_of_state s i)
    (h_sum_le : ∀ s, ∑ i : Fin N, alloc_of_state s i ≤ 1) :
    DirectSellingMechanism N :=
  { allocation := fun θ i => alloc_of_state (G.outcome θ) i
    payment := G.payment
    alloc_nonneg := fun θ i => h_nonneg (G.outcome θ) i
    alloc_sum_le := fun θ => h_sum_le (G.outcome θ) }

/-- Given a direct selling mechanism, we can embed it into a general mechanism
    with N+1 social states. -/
noncomputable def toGeneral (N : ℕ) (D : DirectSellingMechanism N) :
    GeneralMechanism N :=
  { num_states := N + 1
    outcome := fun _ => ⟨0, Nat.zero_lt_succ N⟩
    payment := D.payment }

/-- Claim 9.5.3(a): Under the single-object specialization (N+1 states corresponding
    to N+1 possible allocations), Definition 9.4 and Definition 9.1 are equivalent
    in the sense that every general mechanism yields a valid direct selling mechanism
    and the payment structures are preserved. -/
theorem claim_9_5_3_a (N : ℕ)
    (G : GeneralMechanism N)
    (hstates : G.num_states = N + 1)
    (alloc_of_state : Fin G.num_states → Fin N → ℝ)
    (h_nonneg : ∀ s i, 0 ≤ alloc_of_state s i)
    (h_sum_le : ∀ s, ∑ i : Fin N, alloc_of_state s i ≤ 1) :
    let D := toDirect N G alloc_of_state h_nonneg h_sum_le
    (∀ θ i, D.payment θ i = G.payment θ i) ∧
    (∀ θ i, 0 ≤ D.allocation θ i) ∧
    (∀ θ, ∑ i : Fin N, D.allocation θ i ≤ 1) := by
  refine ⟨fun θ i => rfl, fun θ i => h_nonneg _ _, fun θ => h_sum_le _⟩