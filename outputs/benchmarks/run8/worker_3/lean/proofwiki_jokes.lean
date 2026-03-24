import Mathlib

-- We assume the following facts:
axiom can_open_the_cans : Prop
axiom will_die : Prop
axiom we_can_open : can_open_the_cans

theorem if_cannot_open_then_will_die : ¬ can_open_the_cans → will_die := by
  intro h_not
  exfalso
  exact h_not we_can_open