import Mathlib
open Topology
open Matrix

/-- The Slutsky substitution matrix S(p, w) is the L × L matrix with entries
    s_{ℓk}(p, w) = ∂x_ℓ(p, w)/∂p_k + [∂x_ℓ(p, w)/∂w] · x_k(p, w).
    It equals D_p h(p, u) where u = v(p, w). -/
noncomputable def slutsky_matrix
    {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ)
    (w : ℝ) : Matrix (Fin L) (Fin L) ℝ :=
  Matrix.of fun ℓ k =>
    fderiv ℝ (fun p' => x p' w ℓ) p (Pi.single k 1) +
    deriv (fun w' => x p w' ℓ) w * x p w k