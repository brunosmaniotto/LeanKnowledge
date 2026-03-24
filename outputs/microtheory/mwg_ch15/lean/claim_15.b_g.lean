import Mathlib

section WalrasianEquilibrium

variable {X : Type*}
variable (u : X → ℝ)
variable (affordable : X → Prop)
variable (ω x_star : X)

theorem walrasian_equilibrium_individually_rational
    (h_endowment_affordable : affordable ω)
    (h_optimal : ∀ y : X, affordable y → u y ≤ u x_star) :
    u ω ≤ u x_star :=
  h_optimal ω h_endowment_affordable

end WalrasianEquilibrium