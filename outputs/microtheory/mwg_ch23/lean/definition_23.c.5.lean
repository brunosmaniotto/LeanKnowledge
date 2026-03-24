import Mathlib

variable {Agent Alternative : Type*} [Fintype Agent] [DecidableEq Alternative]

/-- Definition 23.C.5: A social choice function is monotonic. -/
def IsMonotonicSCF
    (f : (Agent → Alternative → Alternative → Prop) → Alternative)
    (L : (Agent → Alternative → Alternative → Prop) → Agent → Alternative → Set Alternative) :
    Prop :=
  ∀ (θ θ' : Agent → Alternative → Alternative → Prop),
    (∀ i, L θ i (f θ) ⊆ L θ' i (f θ)) → f θ' = f θ