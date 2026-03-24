import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- When all values in a family are equal, the "covariance" sum
    ∑ i, (f i - μ) * (g i - ν) vanishes, because f i - μ = 0 for all i.
    This captures why C(p,w) = 0 when wealth effects or scaled consumption
    are equal across consumers. -/
theorem covariance_zero_of_constant_factor
    {ι : Type*} [DecidableEq ι] (s : Finset ι) (hs : s.Nonempty)
    (f g : ι → ℝ) (c : ℝ) (hf : ∀ i ∈ s, f i = c) (μ : ℝ) (hμ : μ = c) :
    ∑ i ∈ s, (f i - μ) * (g i - μ) = 0 := by
  apply Finset.sum_eq_zero
  intro i hi
  have : f i - μ = 0 := by rw [hμ, hf i hi, sub_self]
  rw [this, zero_mul]