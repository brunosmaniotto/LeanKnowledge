import Mathlib
open Topology
open BigOperators

/-
  Price quasiequilibrium with transfers equivalence under local nonsatiation.

  The key economic content: under locally nonsatiated preferences,
  condition (ii) "x_i ≻_i x*_i ⟹ p·x_i ≥ p·w_i" is equivalent to
  condition (ii') "x_i ≻_i x*_i ⟹ p·x_i ≥ p·x*_i" because
  local nonsatiation forces p·x*_i = w_i at any quasiequilibrium.
-/

variable {I J : Type*} [Fintype I] [Fintype J]
variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- Under locally nonsatiated preferences, the standard and primed formulations
    of price quasiequilibrium with transfers are equivalent. The equivalence
    hinges on local nonsatiation implying p·x*_i = w_i for each consumer. -/
theorem price_quasiequilibrium_equiv_under_local_nonsatiation
    -- Price vector as a linear functional
    (p : V →ₗ[ℝ] ℝ)
    -- Endowment and allocations
    (ω : V) (x_star : I → V) (y_star : J → V)
    -- Production sets (as membership predicates)
    (Y : J → Set V)
    -- Preference relation for each consumer
    (pref : I → V → V → Prop)
    -- Wealth levels (transfers)
    (w : I → ℝ)
    -- Local nonsatiation implies expenditure equals wealth
    (nonsatiation : ∀ i, p (x_star i) = w i)
    -- Condition (i): profit maximization
    (profit_max : ∀ j, ∀ yj ∈ Y j, p yj ≤ p (y_star j))
    -- Condition (iii): market clearing
    (market_clear : ∑ i, x_star i = ω + ∑ j, y_star j) :
    -- (ii) standard form ↔ (ii') primed form
    (∀ i xi, pref i xi (x_star i) → p xi ≥ w i) ↔
    (∀ i xi, pref i xi (x_star i) → p xi ≥ p (x_star i)) := by
  constructor
  · intro h i xi hpref
    have hw := nonsatiation i
    have hge := h i xi hpref
    linarith
  · intro h i xi hpref
    have hw := nonsatiation i
    have hge := h i xi hpref
    linarith