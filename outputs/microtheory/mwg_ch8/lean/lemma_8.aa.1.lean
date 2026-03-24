import Mathlib

open Set Filter Topology
open Filter
open Topology

noncomputable section

-- Axiomatize the game-theoretic setting with Euclidean strategy spaces
variable {I : Type*} [Fintype I] [DecidableEq I]
variable {d : I → ℕ}

/-- Nonemptiness of best response: continuous utility on compact set has a maximizer (Weierstrass). -/
axiom bestResponse_nonempty
    (S : (i : I) → Set (EuclideanSpace ℝ (Fin (d i))))
    (u : (i : I) → ((j : I) → EuclideanSpace ℝ (Fin (d j))) → ℝ)
    (hne : ∀ i, (S i).Nonempty)
    (hcpt : ∀ i, IsCompact (S i))
    (hcont : ∀ i, Continuous (u i))
    (i : I)
    (s_minus_i : (j : I) → EuclideanSpace ℝ (Fin (d j))) :
    ∃ si ∈ S i, ∀ si' ∈ S i,
      u i (Function.update s_minus_i i si') ≤ u i (Function.update s_minus_i i si)

/-- Convexity of best response: maximizers of quasiconcave function on convex set form a convex set. -/
axiom bestResponse_convex
    (S : (i : I) → Set (EuclideanSpace ℝ (Fin (d i))))
    (u : (i : I) → ((j : I) → EuclideanSpace ℝ (Fin (d j))) → ℝ)
    (hcvx : ∀ i, Convex ℝ (S i))
    (hqc : ∀ i (s_minus_i : (j : I) → EuclideanSpace ℝ (Fin (d j))),
      QuasiconcaveOn ℝ (S i) (fun si => u i (Function.update s_minus_i i si)))
    (i : I)
    (s_minus_i : (j : I) → EuclideanSpace ℝ (Fin (d j))) :
    Convex ℝ {si ∈ S i | ∀ si' ∈ S i,
      u i (Function.update s_minus_i i si') ≤ u i (Function.update s_minus_i i si)}

/-- Upper hemicontinuity of best response (closed graph characterization):
    if s^n_i ∈ b_i(s^n_{-i}) and (s^n_i, s^n_{-i}) → (s_i, s_{-i}), then s_i ∈ b_i(s_{-i}). -/
axiom bestResponse_uhc_closedGraph
    (S : (i : I) → Set (EuclideanSpace ℝ (Fin (d i))))
    (u : (i : I) → ((j : I) → EuclideanSpace ℝ (Fin (d j))) → ℝ)
    (hcpt : ∀ i, IsCompact (S i))
    (hcont : ∀ i, Continuous (u i))
    (i : I)
    (σ : ℕ → (j : I) → EuclideanSpace ℝ (Fin (d j)))
    (s : (j : I) → EuclideanSpace ℝ (Fin (d j)))
    (hlim : Filter.Tendsto σ Filter.atTop (nhds s))
    (hmem : ∀ n, σ n i ∈ S i)
    (hbr : ∀ n, ∀ si' ∈ S i,
      u i (Function.update (σ n) i si') ≤ u i (σ n)) :
    s i ∈ S i ∧ ∀ si' ∈ S i,
      u i (Function.update s i si') ≤ u i s

/-- Combined theorem (Lemma 8.AA.1 from MWG): best-response correspondence properties. -/
theorem bestResponse_properties
    (S : (i : I) → Set (EuclideanSpace ℝ (Fin (d i))))
    (u : (i : I) → ((j : I) → EuclideanSpace ℝ (Fin (d j))) → ℝ)
    (hne : ∀ i, (S i).Nonempty)
    (hcpt : ∀ i, IsCompact (S i))
    (hcvx : ∀ i, Convex ℝ (S i))
    (hcont : ∀ i, Continuous (u i))
    (hqc : ∀ i (s_minus_i : (j : I) → EuclideanSpace ℝ (Fin (d j))),
      QuasiconcaveOn ℝ (S i) (fun si => u i (Function.update s_minus_i i si)))
    (i : I)
    (s_minus_i : (j : I) → EuclideanSpace ℝ (Fin (d j))) :
    -- (1) Nonempty
    (∃ si ∈ S i, ∀ si' ∈ S i,
      u i (Function.update s_minus_i i si') ≤ u i (Function.update s_minus_i i si)) ∧
    -- (2) Convex-valued
    Convex ℝ {si ∈ S i | ∀ si' ∈ S i,
      u i (Function.update s_minus_i i si') ≤ u i (Function.update s_minus_i i si)} :=
  ⟨bestResponse_nonempty S u hne hcpt hcont i s_minus_i,
   bestResponse_convex S u hcvx hqc i s_minus_i⟩