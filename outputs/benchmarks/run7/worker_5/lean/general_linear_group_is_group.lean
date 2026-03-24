import Mathlib

open Matrix

instance {K : Type} [Field K] (n : ℕ) : Group (GL (Fin n) K) := by
  infer_instance