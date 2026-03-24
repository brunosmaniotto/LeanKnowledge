import Mathlib

open Topology Filter
open Filter

/-- If f is continuous, small changes in the vector of inputs lead to
    small changes in the amount of output produced. -/
theorem Claim_3_2_a {n : ℕ} (f : (Fin n → ℝ) → ℝ) (hf : Continuous f)
    (z : Fin n → ℝ) :
    Tendsto f (𝓝 z) (𝓝 (f z)) :=
  hf.continuousAt