import Mathlib
open Topology

/-- A contract specifies a wage and a task level. -/
structure Contract where
  wage : ℝ
  task : ℝ

/-- Worker type, parameterized by a productivity parameter θ. -/
structure WorkerType where
  θ : ℝ

/-- A worker's utility from a contract, given their type. -/
noncomputable def workerUtility (w : WorkerType) (c : Contract) : ℝ :=
  c.wage - c.task / w.θ

/-- The screening game is a two-stage game between two firms and
    a population of workers of various types.
    Stage 1: firms simultaneously announce finite sets of contracts.
    Stage 2: workers choose whether to accept a contract and which one,
    with tie-breaking by lower task level and accepting when indifferent.
    If a worker's most preferred contract is offered by both firms,
    she accepts each with probability 1/2. -/
structure ScreeningGame where
  /-- The set of worker types in the economy. -/
  types : Set WorkerType
  /-- Each worker type has a reservation utility (outside option). -/
  reservationUtility : WorkerType → ℝ
  /-- Stage 1: Each firm (indexed by Fin 2) announces a finite set of contracts. -/
  offered : Fin 2 → Finset Contract
  /-- Stage 2: Each worker type chooses at most one contract (or rejects all).
      `none` means the worker rejects all offers. -/
  workerChoice : WorkerType → Option Contract
  /-- The probability that a worker accepting contract c is allocated to firm i.
      Models the 1/2 split when both firms offer the same contract. -/
  allocProb : WorkerType → Contract → Fin 2 → ℝ
  /-- Workers accept employment only if weakly preferred to reservation utility. -/
  voluntary : ∀ (w : WorkerType), w ∈ types →
    ∀ (c : Contract), workerChoice w = some c →
    workerUtility w c ≥ reservationUtility w
  /-- Chosen contracts must be among those offered by at least one firm. -/
  choiceValid : ∀ (w : WorkerType), w ∈ types →
    ∀ (c : Contract), workerChoice w = some c →
    c ∈ offered 0 ∨ c ∈ offered 1
  /-- Tie-breaking rule 1: if indifferent between contracts, choose the one
      with lower task level. -/
  tiebreakTask : ∀ (w : WorkerType), w ∈ types →
    ∀ (c₁ c₂ : Contract), c₁ ≠ c₂ →
    workerUtility w c₁ = workerUtility w c₂ →
    workerChoice w = some c₁ →
    c₁.task ≤ c₂.task
  /-- Tie-breaking rule 2: if indifferent between accepting and rejecting,
      the worker accepts employment. -/
  tiebreakAccept : ∀ (w : WorkerType), w ∈ types →
    ∀ (c : Contract),
    (c ∈ offered 0 ∨ c ∈ offered 1) →
    workerUtility w c = reservationUtility w →
    ∃ c', workerChoice w = some c'
  /-- When the chosen contract is offered by both firms, allocation is 1/2 each. -/
  allocBoth : ∀ (w : WorkerType) (c : Contract) (i : Fin 2),
    workerChoice w = some c →
    c ∈ offered 0 → c ∈ offered 1 →
    allocProb w c i = 1 / 2
  /-- When the chosen contract is offered by exactly one firm, that firm gets probability 1. -/
  allocOne : ∀ (w : WorkerType) (c : Contract) (i : Fin 2),
    workerChoice w = some c →
    c ∈ offered i → c ∉ offered (1 - i) →
    allocProb w c i = 1