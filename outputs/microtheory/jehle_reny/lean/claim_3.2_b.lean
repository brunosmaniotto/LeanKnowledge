import Mathlib
open Topology

theorem claim_3_2_b
    {n : ℕ} (f : (Fin n → ℝ) → ℝ)
    (hf : StrictMono f)
    (x x' : Fin n → ℝ)
    (hxx : x < x') :
    f x < f x' :=
  hf hxx