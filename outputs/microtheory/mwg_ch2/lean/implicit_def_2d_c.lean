import Mathlib
open BigOperators

/-- A consumption bundle `x ∈ ℝ^L₊` is affordable at prices `p` and wealth `w`
    if the total cost `p · x = ∑ᵢ pᵢ xᵢ` does not exceed `w`. -/
def Affordable (L : ℕ) (p x : Fin L → ℝ) (w : ℝ) : Prop :=
  ∑ i, p i * x i ≤ w