import Mathlib

variable {Outcome TypeI TypeOthers : Type*}

def DSIC (f : TypeI → TypeOthers → Outcome) (u : Outcome → TypeI → ℝ) : Prop :=
  ∀ (θ_i θ_i' : TypeI) (θ_others : TypeOthers),
    u (f θ_i θ_others) θ_i ≥ u (f θ_i' θ_others) θ_i