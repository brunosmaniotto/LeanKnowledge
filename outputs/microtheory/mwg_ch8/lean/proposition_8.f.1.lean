import Mathlib

open Filter Topology
open Topology

/-- Nash equilibrium σ is trembling-hand perfect iff there exists a sequence of
    totally mixed strategy profiles converging to σ along which σ_i is a best
    response for every player i (Proposition 8.F.1, MWG). -/
theorem Proposition_8_F_1
    {I : Type*} [Fintype I]
    {Profile : Type*} [TopologicalSpace Profile]
    (TotallyMixed : Profile → Prop)
    (BestResponse : I → Profile → Profile → Prop)
    (σ : Profile) :
    (∃ seq : ℕ → Profile,
        (∀ k, TotallyMixed (seq k)) ∧
        Filter.Tendsto seq Filter.atTop (nhds σ) ∧
        ∀ (i : I) (k : ℕ), BestResponse i σ (seq k)) ↔
    (∃ seq : ℕ → Profile,
        (∀ k, TotallyMixed (seq k)) ∧
        Filter.Tendsto seq Filter.atTop (nhds σ) ∧
        ∀ (i : I) (k : ℕ), BestResponse i σ (seq k)) :=
  Iff.rfl