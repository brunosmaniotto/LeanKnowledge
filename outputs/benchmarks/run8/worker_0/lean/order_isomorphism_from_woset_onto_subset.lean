import Mathlib

open Set

theorem Order_Isomorphism_from_Woset_onto_Subset {S : Type _} [LinearOrder S] 
    (h_wf : WellFounded (· < · : S → S → Prop)) (T : Set S) (f : S ≃o T) :
    ∀ x : S, x ≤ f x := by
  let A : Set S := {x | (f x : S) < x}
  by_cases hA : A.Nonempty
  · obtain ⟨a, ha, ha_min⟩ := h_wf.has_min A hA
    have h1 : (f a : S) < a := ha
    have h2 : (f (f a : S) : S) < (f a : S) := f.strictMono h1
    have h3 : (f a : S) ∈ A := h2
    have h4 : ¬ (f a : S) < a := ha_min (f a : S) h3
    exact absurd h1 h4
  · intro x
    have h : ¬ (f x : S) < x := fun h' => hA ⟨x, h'⟩
    exact le_of_not_gt h