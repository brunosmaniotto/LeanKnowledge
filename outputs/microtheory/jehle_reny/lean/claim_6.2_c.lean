import Mathlib
open Finset

/-- A complete and transitive relation on a finite type induces a total ranking:
    every element can be placed in a hierarchy from best to worst. -/
theorem social_preference_hierarchy
    {X : Type*} [Fintype X] [DecidableEq X]
    (R : X → X → Prop) [DecidableRel R]
    (complete : ∀ x y : X, R x y ∨ R y x)
    (trans : ∀ x y z : X, R x y → R y z → R x z) :
    ∃ rank : X → ℕ,
      ∀ x y : X, R x y → rank y ≤ rank x := by
  -- Define rank(x) = number of elements weakly preferred to x (i.e., that x is at least as good as)
  -- If R x y (x is at least as good as y), then everything y is at least as good as,
  -- x is also at least as good as, so rank y ≤ rank x.
  refine ⟨fun x => Finset.card (Finset.univ.filter (fun z => R x z)), ?_⟩
  intro x y hxy
  apply Finset.card_le_card
  intro z hz
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hz ⊢
  exact trans x y z hxy hz