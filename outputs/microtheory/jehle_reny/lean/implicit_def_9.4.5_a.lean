import Mathlib

open Set

/-- The optimality condition for the reserve price in a symmetric auction (eq. 9.19):
    ρ · f(ρ) + F(ρ) = 1, equivalently ρ - (1 - F(ρ))/f(ρ) = 0 when f(ρ) > 0. -/
def IsOptimalReservePrice (F f : ℝ → ℝ) (ρ : ℝ) : Prop :=
  ρ ∈ Icc (0 : ℝ) 1 ∧ ρ * f ρ + F ρ = 1

/-- The optimal reserve price ρ* ∈ [0,1], the unique solution to
    ρ* - (1 - F(ρ*))/f(ρ*) = 0 (equation 9.19). -/
noncomputable def optimalReservePrice (F f : ℝ → ℝ) : ℝ :=
  Classical.epsilon (IsOptimalReservePrice F f)