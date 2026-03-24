import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {L : ℕ} -- number of commodities

/-- The price simplex: nonneg vectors summing to 1 -/
def PriceSimplex (L : ℕ) : Set (Fin L → ℝ) :=
  {p | (∀ ℓ, 0 ≤ p ℓ) ∧ ∑ ℓ : Fin L, p ℓ = 1}

/-- Dot product of two vectors in ℝ^L -/
noncomputable def dot {L : ℕ} (p x : Fin L → ℝ) : ℝ :=
  ∑ ℓ : Fin L, p ℓ * x ℓ

/-- Consumer i's wealth: endowment value plus nonneg share of profits -/
noncomputable def consumerWealth {L I J : ℕ}
    (ω : Fin I → Fin L → ℝ)
    (θ : Fin I → Fin J → ℝ)
    (p : Fin L → ℝ)
    (y : Fin J → Fin L → ℝ)
    (i : Fin I) : ℝ :=
  dot p (ω i) + max 0 (∑ j : Fin J, θ i j * dot p (y j))

/-- Consumer i's budget set given prices and production -/
noncomputable def budgetSet {L I J : ℕ}
    (X : Fin I → Set (Fin L → ℝ))
    (ω : Fin I → Fin L → ℝ)
    (θ : Fin I → Fin J → ℝ)
    (p : Fin L → ℝ)
    (y : Fin J → Fin L → ℝ)
    (i : Fin I) : Set (Fin L → ℝ) :=
  {xi ∈ X i | dot p xi ≤ consumerWealth ω θ p y i}

/-- Consumer i's best response: budget-feasible bundles preferred to all other feasible bundles -/
noncomputable def consumerBestResponse {L I J : ℕ}
    (X : Fin I → Set (Fin L → ℝ))
    (ω : Fin I → Fin L → ℝ)
    (θ : Fin I → Fin J → ℝ)
    (pref : Fin I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (p : Fin L → ℝ)
    (y : Fin J → Fin L → ℝ)
    (i : Fin I) : Set (Fin L → ℝ) :=
  {xi' ∈ budgetSet X ω θ p y i |
    ∀ xi ∈ budgetSet X ω θ p y i, pref i xi' xi}

/-- Firm j's best response: profit-maximizing production plans -/
noncomputable def firmBestResponse {L J : ℕ}
    (Y : Fin J → Set (Fin L → ℝ))
    (p : Fin L → ℝ)
    (j : Fin J) : Set (Fin L → ℝ) :=
  {yj' ∈ Y j | ∀ yj ∈ Y j, dot p yj ≤ dot p yj'}

/-- Excess demand: aggregate consumption minus endowments minus production -/
noncomputable def excessDemand {L I J : ℕ}
    (x : Fin I → Fin L → ℝ)
    (ω : Fin I → Fin L → ℝ)
    (y : Fin J → Fin L → ℝ) : Fin L → ℝ :=
  fun ℓ => ∑ i : Fin I, x i ℓ - ∑ i : Fin I, ω i ℓ - ∑ j : Fin J, y j ℓ

/-- Market agent's best response: price in simplex maximizing value of excess demand -/
noncomputable def marketBestResponse {L I J : ℕ}
    (x : Fin I → Fin L → ℝ)
    (ω : Fin I → Fin L → ℝ)
    (y : Fin J → Fin L → ℝ) : Set (Fin L → ℝ) :=
  {q ∈ PriceSimplex L |
    ∀ q' ∈ PriceSimplex L, dot q' (excessDemand x ω y) ≤ dot q (excessDemand x ω y)}

/-- The noncooperative game for existence of competitive equilibrium.
    Players: I consumers + J firms + 1 market agent.
    Encodes strategy sets and best-response correspondences. -/
structure ExistenceGame (L I J : ℕ) where
  /-- Consumer i's strategy set X̂_i -/
  consumerStrategy : Fin I → Set (Fin L → ℝ)
  /-- Firm j's strategy set Ŷ_j -/
  firmStrategy : Fin J → Set (Fin L → ℝ)
  /-- Initial endowments -/
  endowment : Fin I → Fin L → ℝ
  /-- Ownership shares θ_{ij} -/
  shares : Fin I → Fin J → ℝ
  /-- Preference relations (i prefers first arg to second) -/
  pref : Fin I → (Fin L → ℝ) → (Fin L → ℝ) → Prop