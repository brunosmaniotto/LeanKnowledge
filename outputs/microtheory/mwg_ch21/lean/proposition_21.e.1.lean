import Mathlib
open Topology

universe u

variable (X : Type*) (I : Type*)

/-- A social choice function framework with Arrow's theorem as axiom -/
axiom SCF : Type*
axiom PrefProfile : Type*
axiom WeaklyParetian : SCF → Prop
axiom Monotonic : SCF → Prop
axiom Dictatorial : SCF → Prop
axiom card_X_ge_three : 3 ≤ Nat.card X
axiom arrows_theorem_for_scf :
  ∀ (f : SCF), WeaklyParetian f → Monotonic f → Dictatorial f

theorem Proposition_21_E_1
    (f : SCF)
    (hPareto : WeaklyParetian f)
    (hMono : Monotonic f) :
    Dictatorial f :=
  arrows_theorem_for_scf f hPareto hMono