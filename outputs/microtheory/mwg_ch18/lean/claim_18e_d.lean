import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

/-- In a finite economy, the sum of discrete marginal contributions strictly exceeds
    total welfare, so no feasible allocation can give each consumer her full marginal
    contribution. -/
theorem claim_18E_d
    {H : Type*} [Fintype H] [DecidableEq H]
    (I : H → ℝ)                          -- income profile
    (v : ℝ)                               -- total social welfare v(I₁,...,I_H)
    (Δv : H → ℝ)                          -- discrete marginal contribution Δ_h v
    (dv : H → ℝ)                          -- partial derivative ∂v/∂μ_h
    (hconc : ∀ h, Δv h ≥ dv h)           -- concavity: Δ_h v ≥ ∂v/∂μ_h
    (hstrict : ∃ h, Δv h > dv h)         -- generically strict for some h
    (hI_pos : ∀ h, I h > 0)              -- positive incomes
    (heuler : ∑ h : H, I h * dv h = v)   -- Euler's formula: Σ I_h (∂v/∂μ_h) = v
    : ∑ h : H, I h * Δv h > v := by
  rw [← heuler]
  obtain ⟨h₀, hh₀⟩ := hstrict
  calc ∑ h : H, I h * Δv h
      = ∑ h : H, (I h * dv h + I h * (Δv h - dv h)) := by
        congr 1; ext h; ring
    _ = ∑ h : H, I h * dv h + ∑ h : H, I h * (Δv h - dv h) := by
        rw [Finset.sum_add_distrib]
    _ > ∑ h : H, I h * dv h := by
        linarith [Finset.single_le_sum
          (f := fun h => I h * (Δv h - dv h))
          (fun h _ => mul_nonneg (le_of_lt (hI_pos h)) (sub_nonneg.mpr (hconc h)))
          (Finset.mem_univ h₀),
          mul_pos (hI_pos h₀) (sub_pos.mpr hh₀)]