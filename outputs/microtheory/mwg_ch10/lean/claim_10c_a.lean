import Mathlib

open Set
open Topology

variable {p : ℝ} {c : ℝ → ℝ} {q_j_star : ℝ}

-- Define the profit function explicitly to avoid type inference issues within the theorem hypothesis
def profit_fun (q : ℝ) : ℝ := p * q - c q