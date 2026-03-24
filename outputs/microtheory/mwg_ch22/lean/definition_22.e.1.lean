import Mathlib

/-- A bargaining problem consists of a utility possibility set U and a disagreement point u*. -/
structure BargainingProblem (I : Type*) where
  U : Set (I → ℝ)
  disagreement : I → ℝ
  disagreement_mem : disagreement ∈ U

/-- A bargaining solution assigns to every bargaining problem (U, u*) a solution vector f(U, u*) ∈ U. -/
structure BargainingSolution (I : Type*) where
  f : BargainingProblem I → (I → ℝ)
  mem : ∀ (bp : BargainingProblem I), f bp ∈ bp.U