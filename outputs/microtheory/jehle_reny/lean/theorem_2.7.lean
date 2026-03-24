import Mathlib

open BigOperators Finset
open Topology

noncomputable section

/-- Von Neumann–Morgenstern preference framework satisfying axioms G1–G6.
    G is the type of gambles, n is the number of pure outcomes (a₁ ≻ ⋯ ≻ aₙ). -/
structure VNMFramework (G : Type*) (n : ℕ) where
  /-- Weak preference relation ≿ -/
  pref : G → G → Prop
  /-- Binary reference lottery: α on best outcome a₁, (1−α) on worst aₙ -/
  refLot : ℝ → G
  /-- Pure outcome (degenerate gamble on outcome i) -/
  pure : Fin n → G
  /-- Simple gamble from probability vector -/
  simple : (Fin n → ℝ) → G
  /-- G1: Completeness -/
  complete : ∀ g g', pref g g' ∨ pref g' g
  /-- G2: Transitivity -/
  trans : ∀ g g' g'', pref g g' → pref g' g'' → pref g g''
  /-- G3+G4: Each gamble has a unique indifference probability in [0,1] -/
  indiff_exists : ∀ g, ∃! α : ℝ, 0 ≤ α ∧ α ≤ 1 ∧ pref g (refLot α) ∧ pref (refLot α) g
  /-- G4: Monotonicity on binary reference lotteries -/
  ref_mono : ∀ α β, 0 ≤ α → α ≤ 1 → 0 ≤ β → β ≤ 1 →
    (pref (refLot α) (refLot β) ↔ α ≥ β)
  /-- G5+G6: Substitution and reduction — if each pure outcome aᵢ is indifferent
      to refLot(uᵢ), then simple gamble p is indifferent to refLot(∑ pᵢuᵢ) -/
  reduction : ∀ (p u : Fin n → ℝ),
    (∀ i, 0 ≤ p i) → (∑ i, p i = 1) →
    (∀ i, 0 ≤ u i ∧ u i ≤ 1) →
    (∀ i, pref (pure i) (refLot (u i)) ∧ pref (refLot (u i)) (pure i)) →
    0 ≤ ∑ i, p i * u i → ∑ i, p i * u i ≤ 1 →
    pref (simple p) (refLot (∑ i, p i * u i)) ∧
    pref (refLot (∑ i, p i * u i)) (simple p)

namespace VNMFramework

variable {G : Type*} {n : ℕ} (F : VNMFramework G n)

/-- The utility function: u(g) = unique α with g ∼ refLot(α), from G3+G4. -/
def utility (g : G) : ℝ := (F.indiff_exists g).choose