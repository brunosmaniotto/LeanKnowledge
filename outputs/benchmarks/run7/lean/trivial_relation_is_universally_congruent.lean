import Mathlib

theorem trivial_relation_universally_congruent (S : Type u) (f : S → S → S) :
    ∀ (x1 x2 y1 y2 : S), (fun (a b : S) => True) x1 x2 → (fun (a b : S) => True) y1 y2 → (fun (a b : S) => True) (f x1 y1) (f x2 y2) := by
  intro x1 x2 y1 y2 h1 h2
  trivial