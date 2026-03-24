import Mathlib

open Matrix

/-- The price effects matrix D_p x(p, w), an L × L matrix whose (l, k)-th entry
    is ∂x_l(p, w)/∂p_k. Here `x` is a demand function mapping prices and wealth
    to a consumption bundle. -/
noncomputable def priceEffectsMatrix
    {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ)
    (w : ℝ) :
    Matrix (Fin L) (Fin L) ℝ :=
  Matrix.of fun l k =>
    fderiv ℝ (fun p' => x p' w l) p (Pi.single k 1)