import Mathlib
open Topology

noncomputable def budgetShare
    (x : Fin n → ℝ → ℝ → ℝ)
    (p : Fin n → ℝ)
    (w : ℝ)
    (l : Fin n) : ℝ :=
  p l * x l (p l) w / w