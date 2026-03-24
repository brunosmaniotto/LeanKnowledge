import Mathlib

noncomputable section

/-- Producer surplus: revenue minus total variable cost.
    PS(p, q) = p · q − tvc(q) -/
def producerSurplus (p q : ℝ) (tvc : ℝ → ℝ) : ℝ :=
  p * q - tvc q

end