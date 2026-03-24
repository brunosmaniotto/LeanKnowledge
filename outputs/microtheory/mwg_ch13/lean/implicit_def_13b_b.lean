import Mathlib

/-- The set of worker types willing to accept employment at wage rate `w`.
    A worker of type `θ` is willing to work if and only if `r θ ≤ w`. -/
def Theta {Θ : Type*} [Preorder Θ] (r : Θ → ℝ) (w : ℝ) : Set Θ :=
  {θ : Θ | r θ ≤ w}