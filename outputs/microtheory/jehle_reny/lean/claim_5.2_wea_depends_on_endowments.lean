import Mathlib

/-- Claim 5.2: The Walrasian Equilibrium Allocation depends on initial endowments
    and may be quite distinct from a socially optimal allocation.
    Given equilibrium correspondence C and social optimum x̄, if endowments e₁, e₂
    yield distinct equilibria x₁ ≠ x₂, and x₁ ≠ x̄, then:
    (1) equilibrium depends on endowments, and
    (2) equilibrium may not be socially optimal. -/
theorem Claim_5_2_WEA_depends_on_endowments
    {Allocation Endowment : Type*}
    (C : Endowment → Set Allocation)   -- competitive equilibrium correspondence
    (x_bar : Allocation)                -- socially optimal allocation
    (e₁ e₂ : Endowment)
    (x₁ x₂ : Allocation)
    (hx₁ : x₁ ∈ C e₁)                 -- x₁ is an equilibrium at endowment e₁
    (hx₂ : x₂ ∈ C e₂)                 -- x₂ is an equilibrium at endowment e₂
    (h_endow_dep : x₁ ≠ x₂)           -- different endowments yield different equilibria
    (h_not_optimal : x₁ ≠ x_bar) :     -- equilibrium differs from social optimum
    (∃ e e' : Endowment, ∃ a ∈ C e, ∃ a' ∈ C e', a ≠ a') ∧
    (∃ e₀ : Endowment, ∃ a ∈ C e₀, a ≠ x_bar) := by
  constructor
  · exact ⟨e₁, e₂, x₁, hx₁, x₂, hx₂, h_endow_dep⟩
  · exact ⟨e₁, x₁, hx₁, h_not_optimal⟩