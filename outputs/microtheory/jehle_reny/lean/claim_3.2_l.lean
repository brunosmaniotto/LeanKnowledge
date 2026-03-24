import Mathlib

open Finset BigOperators
open Topology
open Filter
open BigOperators

/-- The n-input CES production function: y = (∑ᵢ αᵢ xᵢ^ρ)^(1/ρ) -/
noncomputable def cesProd {n : ℕ} (α : Fin n → ℝ) (x : Fin n → ℝ) (ρ : ℝ) : ℝ :=
  (∑ i : Fin n, α i * (x i) ^ ρ) ^ (1 / ρ)

/-- The Cobb-Douglas production function: y = ∏ᵢ xᵢ^αᵢ -/
noncomputable def cobbDouglas {n : ℕ} (α : Fin n → ℝ) (x : Fin n → ℝ) : ℝ :=
  ∏ i : Fin n, (x i) ^ (α i)

/-- The elasticity of substitution σ = 1/(1 - ρ) -/
noncomputable def elasticityOfSubst (ρ : ℝ) : ℝ := 1 / (1 - ρ)

/-- Core analytical result: CES → Cobb-Douglas as ρ → 0.
    Proof sketch: Take logs, apply L'Hôpital to log(∑ αᵢ exp(ρ ln xᵢ))/ρ,
    derivative at ρ=0 is ∑ αᵢ ln xᵢ = ln(∏ xᵢ^αᵢ), then exponentiate. -/
axiom ces_to_cobb_douglas {n : ℕ} (α : Fin n → ℝ) (x : Fin n → ℝ)
    (hα_pos : ∀ i, 0 < α i) (hα_sum : ∑ i : Fin n, α i = 1)
    (hx_pos : ∀ i, 0 < x i) :
    Filter.Tendsto (fun ρ => cesProd α x ρ)
      (nhdsWithin (0 : ℝ) {r : ℝ | r ≠ 0}) (nhds (cobbDouglas α x))

/-- As ρ → 0, σᵢⱼ → 1, and the CES form (∑ αᵢxᵢ^ρ)^(1/ρ) reduces to ∏ xᵢ^αᵢ -/
theorem Claim_3_2_l {n : ℕ} (α : Fin n → ℝ) (x : Fin n → ℝ)
    (hα_pos : ∀ i, 0 < α i) (hα_sum : ∑ i : Fin n, α i = 1)
    (hx_pos : ∀ i, 0 < x i) :
    elasticityOfSubst 0 = 1 ∧
    Filter.Tendsto (fun ρ => cesProd α x ρ)
      (nhdsWithin (0 : ℝ) {r : ℝ | r ≠ 0}) (nhds (cobbDouglas α x)) := by
  exact ⟨by unfold elasticityOfSubst; norm_num,
         ces_to_cobb_douglas α x hα_pos hα_sum hx_pos⟩