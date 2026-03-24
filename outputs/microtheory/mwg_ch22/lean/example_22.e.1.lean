import Mathlib

open Finset BigOperators

/-- A bargaining problem for a finite set of agents. -/
structure BargainingProblem (ι : Type*) [Fintype ι] where
  U : Set (ι → ℝ)
  nonempty : U.Nonempty
  compact : IsCompact U

/-- The egalitarian bargaining solution assigns to every bargaining problem
    the utility vector in U that maximizes the minimum coordinate (Rawlsian SWF). -/
noncomputable def egalitarianSolution {ι : Type*} [Fintype ι] [Nonempty ι]
    (bp : BargainingProblem ι) : ι → ℝ :=
  Classical.epsilon (fun u => u ∈ bp.U ∧
    ∀ v ∈ bp.U, Finset.inf' Finset.univ Finset.univ_nonempty v ≤
      Finset.inf' Finset.univ Finset.univ_nonempty u)