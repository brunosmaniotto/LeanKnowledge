import Mathlib
open Topology

noncomputable def MRTS
    (f : (Fin n → ℝ) → ℝ) (z : Fin n → ℝ) (ℓ k : Fin n) : ℝ :=
  (fderiv ℝ f z (Pi.single ℓ 1)) / (fderiv ℝ f z (Pi.single k 1))