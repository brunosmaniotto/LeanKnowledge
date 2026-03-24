import Mathlib

noncomputable section

def nonzero_reals : Type := {x : ℝ // x ≠ 0}

namespace nonzero_reals

-- Multiplication on nonzero_reals