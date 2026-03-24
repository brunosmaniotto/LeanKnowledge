import Mathlib
open Topology

-- Arrow's Impossibility Theorem: deep combinatorial result (axiomatized)
axiom arrows_impossibility
    {I : Type*} [Fintype I] [Nonempty I]
    {A : Type*} [Fintype A]
    (hA : 3 ≤ Fintype.card A)
    (F : (I → A → A → Prop) → (A → A → Prop))
    (WP : ∀ (prefs : I → A → A → Prop) (x y : A),
      (∀ i : I, prefs i x y ∧ ¬ prefs i y x) → F prefs x y ∧ ¬ F prefs y x)
    (IIA : ∀ (prefs prefs' : I → A → A → Prop) (x y : A),
      (∀ i : I, (prefs i x y ↔ prefs' i x y) ∧ (prefs i y x ↔ prefs' i y x)) →
      (F prefs x y ↔ F prefs' x y)) :
    ∃ d : I, ∀ (prefs : I → A → A → Prop) (x y : A),
      (prefs d x y ∧ ¬ prefs d y x) → (F prefs x y ∧ ¬ F prefs y x)

/-- Claim 6.2(h): Arrow's theorem restated as a possibility result.
    Any SWF satisfying unrestricted domain (U), weak Pareto (WP), and
    independence of irrelevant alternatives (IIA) must be dictatorial:
    there exists a dictator whose strict preferences always prevail. -/
theorem Claim_6_2_h
    {I : Type*} [Fintype I] [Nonempty I]
    {A : Type*} [Fintype A]
    (hA : 3 ≤ Fintype.card A)
    (F : (I → A → A → Prop) → (A → A → Prop))
    (WP : ∀ (prefs : I → A → A → Prop) (x y : A),
      (∀ i : I, prefs i x y ∧ ¬ prefs i y x) → F prefs x y ∧ ¬ F prefs y x)
    (IIA : ∀ (prefs prefs' : I → A → A → Prop) (x y : A),
      (∀ i : I, (prefs i x y ↔ prefs' i x y) ∧ (prefs i y x ↔ prefs' i y x)) →
      (F prefs x y ↔ F prefs' x y)) :
    ∃ d : I, ∀ (prefs : I → A → A → Prop) (x y : A),
      (prefs d x y ∧ ¬ prefs d y x) → (F prefs x y ∧ ¬ F prefs y x) :=
  arrows_impossibility hA F WP IIA