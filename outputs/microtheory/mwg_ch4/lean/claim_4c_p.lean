import Mathlib
open Topology

variable {ι : Type*} [Fintype ι]
variable {n : ℕ}

theorem gorman_form_implies_equal_wealth_effects_and_WA
    (gorman_form : Prop)
    (equal_wealth_effects : Prop)
    (WA_holds : Prop)
    (prop_4B1 : gorman_form → equal_wealth_effects)
    (claim_i : equal_wealth_effects → WA_holds)
    (hg : gorman_form) : equal_wealth_effects ∧ WA_holds := by
  exact ⟨prop_4B1 hg, claim_i (prop_4B1 hg)⟩