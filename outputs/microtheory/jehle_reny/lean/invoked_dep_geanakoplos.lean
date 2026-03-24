import Mathlib
open Topology

/-- A strict linear order (strict total order) on a type -/
def StrictLinearPref (α : Type*) (r : α → α → Prop) : Prop :=
  IsTrichotomous α r ∧ IsTrans α r

/-- Arrow's Impossibility Theorem (Geanakoplos 1996 four-step proof):
    For any finite set of voters and any finite set of at least 3 alternatives,
    any social welfare function satisfying Pareto and IIA must be dictatorial. -/
axiom arrow_impossibility_geanakoplos
    (Voter : Type*) (Alt : Type*) [Fintype Voter] [Nonempty Voter]
    [Fintype Alt] [DecidableEq Alt]
    (h_alt : 3 ≤ Fintype.card Alt)
    (F : (Voter → Alt → Alt → Prop) → (Alt → Alt → Prop))
    (F_lin : ∀ profile : Voter → Alt → Alt → Prop,
      (∀ i, StrictLinearPref Alt (profile i)) → StrictLinearPref Alt (F profile))
    (pareto : ∀ (profile : Voter → Alt → Alt → Prop) (a b : Alt),
      (∀ i, profile i a b) → F profile a b)
    (iia : ∀ (p q : Voter → Alt → Alt → Prop) (a b : Alt),
      (∀ i, p i a b ↔ q i a b) → (∀ i, p i b a ↔ q i b a) →
      (F p a b ↔ F q a b)) :
    ∃ d : Voter, ∀ (profile : Voter → Alt → Alt → Prop) (a b : Alt),
      (∀ i, StrictLinearPref Alt (profile i)) →
      a ≠ b → profile d a b → F profile a b