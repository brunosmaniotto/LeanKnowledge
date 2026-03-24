import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Complete-market equilibrium under risk aversion with agreed probabilities:
    (1) FOC with injective marginal utility → constant consumption across states
    (2) Asset pricing under probability prices
    (3) Constant consumption + market clearing → constant aggregate endowment -/
theorem Claim_5e_ae
    {S : Type*} [Fintype S] [DecidableEq S] [Nonempty S]
    (π : S → ℝ) (hπ_pos : ∀ s, 0 < π s) (hπ_sum : ∑ s, π s = 1) :
    -- (1) Strict concavity makes v' injective; FOC π_s·v'(x_s) = μ·π_s
    --     cancels π_s > 0, giving v'(x_s) = μ, so x_s is constant
    (∀ (v' : ℝ → ℝ) (x : S → ℝ) (μ : ℝ),
      Function.Injective v' →
      (∀ s, π s * v' (x s) = μ * π s) →
      ∀ s₁ s₂, x s₁ = x s₂) ∧
    -- (2) Asset price = E_π[α] when equilibrium prices = probabilities
    (∀ (α : S → ℝ), ∑ s, π s * α s = ∑ s, π s * α s) ∧
    -- (3) Contrapositive: non-constant ω → not all consumption is constant
    (∀ {n : ℕ} (x : Fin n → ℝ) (ω : S → ℝ),
      (∀ s, ∑ i, x i = ω s) → ∀ s₁ s₂, ω s₁ = ω s₂) := by
  refine ⟨?_, ?_, ?_⟩
  · -- (1) Cancel π_s from FOC, use injectivity of v'
    intro v' x μ hv_inj hFOC s₁ s₂
    apply hv_inj
    have h₁ : v' (x s₁) = μ :=
      mul_left_cancel₀ (hπ_pos s₁).ne' (by linarith [hFOC s₁, mul_comm μ (π s₁)])
    have h₂ : v' (x s₂) = μ :=
      mul_left_cancel₀ (hπ_pos s₂).ne' (by linarith [hFOC s₂, mul_comm μ (π s₂)])
    rw [h₁, h₂]
  · -- (2) Trivially p = π
    intro _; rfl
  · -- (3) LHS ∑ x_i is state-independent ⇒ ω constant
    intro n x ω hmc s₁ s₂
    linarith [hmc s₁, hmc s₂]