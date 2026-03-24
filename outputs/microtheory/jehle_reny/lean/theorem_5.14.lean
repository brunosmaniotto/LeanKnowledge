import Mathlib

open Finset BigOperators
open BigOperators

/-- **First Welfare Theorem with Production** (Theorem 5.14, Jehle & Reny).
Every Walrasian equilibrium allocation is Pareto efficient when utilities are
strictly increasing. Stated as: market clearing, consumer optimality, and
profit maximization are jointly inconsistent with a Pareto improvement. -/
theorem first_welfare_theorem_production
    {I J : Type*} [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
    (px px' : I → ℝ)   -- p · xⁱ and p · x̂ⁱ
    (py py' : J → ℝ)   -- p · yʲ and p · ŷʲ
    (pe : I → ℝ)        -- p · eⁱ
    -- Market clearing at equilibrium: Σᵢ p·xⁱ = Σⱼ p·yʲ + Σᵢ p·eⁱ
    (hfeas : ∑ i : I, px i = ∑ j : J, py j + ∑ i : I, pe i)
    -- Market clearing for the Pareto-improving allocation
    (hfeas' : ∑ i : I, px' i = ∑ j : J, py' j + ∑ i : I, pe i)
    -- Strict monotonicity + optimality: weakly preferred ⟹ weakly more expensive
    (hge : ∀ i, px' i ≥ px i)
    -- Some consumer strictly better off ⟹ strictly more expensive
    (i₀ : I) (hstrict : px' i₀ > px i₀)
    -- Profit maximization: alternative production plans cannot be more profitable
    (hprofit : ∀ j, py' j ≤ py j) :
    False := by
  -- Σᵢ p·xⁱ < Σᵢ p·x̂ⁱ (all weakly more expensive, one strictly)
  have h1 := Finset.sum_lt_sum (fun i (_ : i ∈ univ) => hge i)
    ⟨i₀, mem_univ i₀, hstrict⟩
  -- Substitute market clearing into both sides
  rw [hfeas, hfeas'] at h1
  -- h1 : Σⱼ p·yʲ + Σᵢ p·eⁱ < Σⱼ p·ŷʲ + Σᵢ p·eⁱ
  -- But profit max gives Σⱼ p·ŷʲ ≤ Σⱼ p·yʲ — contradiction
  linarith [Finset.sum_le_sum (fun j (_ : j ∈ univ) => hprofit j)]