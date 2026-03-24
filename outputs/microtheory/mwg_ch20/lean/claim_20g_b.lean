import Mathlib

open BigOperators Finset

structure InfiniteHorizonModel where
  I : ℕ
  hI : I ≥ 2

noncomputable def equilibriumEquationCount (M : InfiniteHorizonModel) : ℕ := M.I - 1

noncomputable def equilibriumUnknownCount (M : InfiniteHorizonModel) : ℕ := M.I - 1

theorem Claim_20G_b (M : InfiniteHorizonModel) :
    equilibriumEquationCount M = equilibriumUnknownCount M := by
  rfl