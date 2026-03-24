import Mathlib
open Topology

/-- The marginal rate of technical substitution (MRTS) of input `i` for input `j`
    at input vector `x`, defined as the ratio of marginal products:
    MRTSᵢⱼ(x) = (∂f(x)/∂xᵢ) / (∂f(x)/∂xⱼ). -/
noncomputable def MRTS_JR
    {n : ℕ} (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) (i j : Fin n) : ℝ :=
  (fderiv ℝ f x (Pi.single i 1)) / (fderiv ℝ f x (Pi.single j 1))