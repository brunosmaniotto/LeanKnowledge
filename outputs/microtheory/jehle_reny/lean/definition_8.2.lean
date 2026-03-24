import Mathlib

/-- Definition 8.2: Separating if ψ_l ≠ ψ_h, Pooling if ψ_l = ψ_h. -/
def IsSeparating {Action : Type*} (ψ_l ψ_h : Action) : Prop := ψ_l ≠ ψ_h