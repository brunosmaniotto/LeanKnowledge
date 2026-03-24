import Mathlib
open Topology

variable {I A : Type*} [Fintype I] [Fintype A] [DecidableEq A] [Nonempty A] [Nonempty I]

theorem dictatorial_scf_pareto_and_monotonic
    (d : I)
    (f : (I → A → A → Prop) → A)
    (h_dict : ∀ P, f P = f (fun _ => P d))
    (h_pareto_d : ∀ (P : I → A → A → Prop) (a b : A),
      P d a b → f (fun _ => P d) ≠ b ∨ a = b)
    : (∀ (P P' : I → A → A → Prop) (a : A), f P = a →
        (∀ b, P d a b → P' d a b) →
        f (fun _ => P' d) = f (fun _ => P d) →
        f P' = a) := by
  intro P P' a hfP hPres heq
  rw [h_dict P] at hfP
  rw [h_dict P']
  rw [← hfP]
  exact heq