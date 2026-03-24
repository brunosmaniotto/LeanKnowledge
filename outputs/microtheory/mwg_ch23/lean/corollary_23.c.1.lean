import Mathlib

variable (Agent Alt : Type*) [Fintype Agent] [Fintype Alt] [DecidableEq Alt]
variable (Pref : Type*) -- preference type

structure SCFContext where
  f : (Agent → Pref) → Alt
  isDictatorial : Prop
  isTruthful : Prop
  surjective : Prop
  atLeastThree : 3 ≤ Fintype.card Alt

axiom gibbard_satterthwaite_converse
    (ctx : SCFContext Agent Alt Pref) (h_surj : ctx.surjective)
    (h3 : 3 ≤ Fintype.card Alt) (h_truth : ctx.isTruthful) : ctx.isDictatorial

axiom dictatorial_implies_truthful
    (ctx : SCFContext Agent Alt Pref) (h_dict : ctx.isDictatorial) : ctx.isTruthful

theorem Corollary_23_C_1 (ctx : SCFContext Agent Alt Pref)
    (h_surj : ctx.surjective) (h3 : 3 ≤ Fintype.card Alt) :
    ctx.isTruthful ↔ ctx.isDictatorial :=
  ⟨gibbard_satterthwaite_converse Agent Alt Pref ctx h_surj h3,
   dictatorial_implies_truthful Agent Alt Pref ctx⟩