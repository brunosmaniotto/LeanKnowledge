import Mathlib
open Topology

-- Price equilibrium with transfers: if x_i is strictly preferred to x*_i, then p·x_i > w_i
theorem price_equilibrium_strict_preference_unaffordable
    {X : Type*} [Nonempty X]
    (preferred : X → X → Prop)          -- strict preference ≻_i
    (weakly_preferred : X → X → Prop)   -- weak preference ≽_i
    (cost : X → ℝ)                      -- p · x_i
    (w : ℝ)                             -- wealth w_i
    (x_star : X)                        -- equilibrium allocation x*_i
    -- Utility maximization: x*_i maximizes preference among affordable bundles
    (h_max : ∀ y, cost y ≤ w → weakly_preferred x_star y)
    -- Strict preference implies not weakly preferred the other way
    (h_strict : ∀ a b, preferred a b → ¬ weakly_preferred b a)
    (x_i : X)
    (h_pref : preferred x_i x_star) :
    cost x_i > w := by
  by_contra h
  push_neg at h
  exact h_strict x_i x_star h_pref (h_max x_i h)