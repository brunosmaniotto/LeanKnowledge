import Mathlib
open Topology

/-- A contrapositive proof of 'A ⇒ B' proceeds by assuming ¬B and showing ¬A,
    taking advantage of the logical equivalence between 'A ⇒ B' and '¬B → ¬A'. -/
def contrapositive_equiv (A B : Prop) : (A → B) ↔ (¬B → ¬A) :=
  ⟨fun h hnb ha => hnb (h ha), fun h ha => by_contra fun hnb => h hnb ha⟩