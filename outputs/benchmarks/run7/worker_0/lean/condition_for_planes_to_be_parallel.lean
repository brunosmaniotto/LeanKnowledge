import Mathlib

open Set

-- Define a plane in ℝ³ by a linear equation: ∑ i, a i * x i = γ, with a ≠ 0.
def plane (a : Fin 3 → ℝ) (γ : ℝ) : Set (Fin 3 → ℝ) :=
  {x | ∑ i : Fin 3, a i * x i = γ}

-- Axiom: if two planes are parallel (equal or disjoint), then their normal vectors are scalar multiples.
axiom parallel_implies_same_normal (a b : Fin 3 → ℝ) (γ δ : ℝ) (ha : a ≠ 0) (hb : b ≠ 0) :
  (plane a γ = plane b δ ∨ Disjoint (plane a γ) (plane b δ)) → ∃ c : ℝ, b = c • a

-- Lemma: two planes with the same normal vector are parallel (equal if same constant, disjoint otherwise).