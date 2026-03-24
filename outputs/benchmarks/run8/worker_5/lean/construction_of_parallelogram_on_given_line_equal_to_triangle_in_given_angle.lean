import Mathlib
open Real
open FiniteDimensional

-- Define the Euclidean plane as ℝ²
abbrev EuclideanPlane := EuclideanSpace ℝ (Fin 2)

-- Parallelogram condition: L - A = M - B
def isParallelogram (A B M L : EuclideanPlane) : Prop := L - A = M - B

-- Determinant of two vectors in ℝ²