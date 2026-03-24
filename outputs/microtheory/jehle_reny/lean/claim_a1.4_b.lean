import Mathlib
open Topology

theorem claim_A1_4_b
    {n : ℕ} {D : Set (Fin n → ℝ)} {f : (Fin n → ℝ) → ℝ}
    (hf : StrictMono f)
    (x0 x2 : Fin n → ℝ)
    (hlt : x2 < x0) :
    f x2 < f x0 :=
  hf hlt