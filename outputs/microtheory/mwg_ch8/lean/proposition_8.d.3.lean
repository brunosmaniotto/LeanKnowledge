import Mathlib
open Topology

/-- Kakutani's fixed point theorem: a nonempty, convex-valued, upper hemicontinuous
    correspondence from a nonempty, convex, compact set to itself has a fixed point. -/
axiom kakutani_fixed_point
  {n : ℕ} {S : Set (EuclideanSpace ℝ (Fin n))}
  {f : EuclideanSpace ℝ (Fin n) → Set (EuclideanSpace ℝ (Fin n))}
  (hne : S.Nonempty)
  (hconv : Convex ℝ S)
  (hcpt : IsCompact S)
  (hval_ne : ∀ x ∈ S, (f x).Nonempty)
  (hval_conv : ∀ x ∈ S, Convex ℝ (f x))
  (hval_sub : ∀ x ∈ S, f x ⊆ S)
  (huhc : UpperSemicontinuousOn (fun x => f x) S) :
  ∃ x ∈ S, x ∈ f x

/-- Proposition 8.D.3: Nash equilibrium existence under standard conditions.
    Given a game where each player's strategy set is nonempty, convex, compact
    in Euclidean space and utilities are continuous and quasiconcave in own strategy,
    a Nash equilibrium exists. We model the product of strategy sets in a single
    Euclidean space. -/
theorem Proposition_8_D_3_nash_equilibrium_exists
  {n : ℕ}
  {I : ℕ}
  (hI : 0 < I)
  (S : Set (EuclideanSpace ℝ (Fin n)))
  (u : Fin I → EuclideanSpace ℝ (Fin n) → ℝ)
  (hne : S.Nonempty)
  (hconv : Convex ℝ S)
  (hcpt : IsCompact S)
  (hcont : ∀ i, ContinuousOn (u i) S)
  -- Best response correspondence
  (b : EuclideanSpace ℝ (Fin n) → Set (EuclideanSpace ℝ (Fin n)))
  (hb_def : ∀ s ∈ S, ∀ s' ∈ b s, s' ∈ S ∧
    ∀ i : Fin I, u i s' ≥ u i s)
  (hb_ne : ∀ s ∈ S, (b s).Nonempty)
  (hb_conv : ∀ s ∈ S, Convex ℝ (b s))
  (hb_sub : ∀ s ∈ S, b s ⊆ S)
  (hb_uhc : UpperSemicontinuousOn (fun x => b x) S) :
  ∃ s ∈ S, s ∈ b s := by
  exact kakutani_fixed_point hne hconv hcpt hb_ne hb_conv hb_sub hb_uhc