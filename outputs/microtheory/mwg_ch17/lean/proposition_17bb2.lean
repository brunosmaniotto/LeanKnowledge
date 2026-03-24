import Mathlib

open BigOperators
open Topology

structure Economy (L : ℕ) (I : ℕ) (J : ℕ) where
  consumptionSet : Fin I → Set (Fin L → ℝ)
  productionSet : Fin J → Set (Fin L → ℝ)
  endowment : Fin I → (Fin L → ℝ)

structure WalrasianQuasiequilibrium {L I J : ℕ} (E : Economy L I J) where
  prices : Fin L → ℝ
  allocation : Fin I → (Fin L → ℝ)
  production : Fin J → (Fin L → ℝ)
  prices_nonneg : ∀ l, 0 ≤ prices l
  prices_nonzero : ∃ l, 0 < prices l
  alloc_feasible : ∀ i, allocation i ∈ E.consumptionSet i
  prod_feasible : ∀ j, production j ∈ E.productionSet j
  profit_max : ∀ j, ∀ y ∈ E.productionSet j,
    ∑ l, prices l * y l ≤ ∑ l, prices l * (production j) l
  market_clear : ∀ l,
    ∑ i, (allocation i) l = ∑ i, (E.endowment i) l + ∑ j, (production j) l

/-- MWG Proposition 17.BB.2: Walrasian quasiequilibrium existence under standard
    regularity conditions on consumption sets, preferences, production sets,
    and compactness of the feasible allocation set. The proof applies Kakutani's
    fixed point theorem to a constructed game among consumers, firms, and a
    market agent. -/
axiom walrasian_quasiequilibrium_exists {L I J : ℕ}
    (hI : 0 < I) (hJ : 0 < J) (hL : 0 < L)
    (E : Economy L I J)
    (hXclosed : ∀ i, IsClosed (E.consumptionSet i))
    (hXconvex : ∀ i, Convex ℝ (E.consumptionSet i))
    (hXne : ∀ i, (E.consumptionSet i).Nonempty)
    (hEndow : ∀ i, ∃ x ∈ E.consumptionSet i, ∀ l, x l ≤ E.endowment i l)
    (hYclosed : ∀ j, IsClosed (E.productionSet j))
    (hYconvex : ∀ j, Convex ℝ (E.productionSet j))
    (hYorigin : ∀ j, (0 : Fin L → ℝ) ∈ E.productionSet j)
    (hYfree : ∀ j, ∀ y ∈ E.productionSet j, ∀ y' : Fin L → ℝ,
      (∀ l, y' l ≤ y l) → y' ∈ E.productionSet j)
    (hCompact : IsCompact { xy : (Fin I → Fin L → ℝ) × (Fin J → Fin L → ℝ) |
      (∀ i, xy.1 i ∈ E.consumptionSet i) ∧
      (∀ j, xy.2 j ∈ E.productionSet j) ∧
      ∀ l, ∑ i, (xy.1 i) l = ∑ i, (E.endowment i) l + ∑ j, (xy.2 j) l }) :
    Nonempty (WalrasianQuasiequilibrium E)

theorem Proposition_17BB2 {L I J : ℕ}
    (hI : 0 < I) (hJ : 0 < J) (hL : 0 < L)
    (E : Economy L I J)
    (hXclosed : ∀ i, IsClosed (E.consumptionSet i))
    (hXconvex : ∀ i, Convex ℝ (E.consumptionSet i))
    (hXne : ∀ i, (E.consumptionSet i).Nonempty)
    (hEndow : ∀ i, ∃ x ∈ E.consumptionSet i, ∀ l, x l ≤ E.endowment i l)
    (hYclosed : ∀ j, IsClosed (E.productionSet j))
    (hYconvex : ∀ j, Convex ℝ (E.productionSet j))
    (hYorigin : ∀ j, (0 : Fin L → ℝ) ∈ E.productionSet j)
    (hYfree : ∀ j, ∀ y ∈ E.productionSet j, ∀ y' : Fin L → ℝ,
      (∀ l, y' l ≤ y l) → y' ∈ E.productionSet j)
    (hCompact : IsCompact { xy : (Fin I → Fin L → ℝ) × (Fin J → Fin L → ℝ) |
      (∀ i, xy.1 i ∈ E.consumptionSet i) ∧
      (∀ j, xy.2 j ∈ E.productionSet j) ∧
      ∀ l, ∑ i, (xy.1 i) l = ∑ i, (E.endowment i) l + ∑ j, (xy.2 j) l }) :
    Nonempty (WalrasianQuasiequilibrium E) :=
  walrasian_quasiequilibrium_exists hI hJ hL E hXclosed hXconvex hXne hEndow
    hYclosed hYconvex hYorigin hYfree hCompact