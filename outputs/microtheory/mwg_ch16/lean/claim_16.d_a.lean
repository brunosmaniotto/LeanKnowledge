import Mathlib
open Topology

theorem price_equilibrium_implies_quasiequilibrium
    {X : Type*} (pref : X → X → Prop) (price : X → ℝ) (w : ℝ) (xstar : X)
    (h_eq : ∀ x, price x ≤ w → ¬pref x xstar)
    : ∀ x, pref x xstar → price x ≥ w := by
  intro x hpref
  by_contra h
  push_neg at h
  exact h_eq x (le_of_lt h) hpref