import Mathlib

/-- Any nonempty finite subset Y of nodes in a well-founded strict-follower
    relation contains a node with no strict follower in Y. -/
theorem exercise_7_31 {Node : Type*} (r : Node → Node → Prop) (wf : WellFounded r)
    (Y : Finset Node) (hY : Y.Nonempty) :
    ∃ y ∈ Y, ∀ z ∈ Y, ¬ r z y := by
  obtain ⟨m, hm, hmin⟩ := wf.has_min Y.toSet hY.to_set
  exact ⟨m, hm, fun z hz hr => hmin z hz hr⟩