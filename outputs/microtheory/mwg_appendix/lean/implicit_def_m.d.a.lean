import Mathlib

open Matrix

/-- A complex number is an eigenvalue of an N×N matrix M if det(M - λ • I) = 0. -/
def MWG.IsEigenvalue {N : Type*} [Fintype N] [DecidableEq N]
    (M : Matrix N N ℂ) (mu : ℂ) : Prop :=
  (M - mu • (1 : Matrix N N ℂ)).det = 0