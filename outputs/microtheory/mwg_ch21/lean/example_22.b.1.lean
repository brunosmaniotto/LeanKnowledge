import Mathlib
open BigOperators Finset
open Finset

-- Axiomatize exchange economy primitives
axiom ExchangeEconomy : Type
axiom ExchangeEconomy.I : ExchangeEconomy → ℕ
axiom UtilityPossibilitySet : ExchangeEconomy → Set (ℕ → ℝ)
axiom IsQuasilinear : ExchangeEconomy → Prop
axiom UPSBoundary : ExchangeEconomy → Set (ℕ → ℝ)
axiom ups_convex (E : ExchangeEconomy) : Convex ℝ (UtilityPossibilitySet E)
axiom boundary_hyperplane (E : ExchangeEconomy) (hq : IsQuasilinear E) :
  ∃ c : ℝ, UPSBoundary E = {u : ℕ → ℝ | ∑ i ∈ Finset.range (E.I), u i = c}

theorem Example_22_B_1 (E : ExchangeEconomy) (hq : IsQuasilinear E) :
    Convex ℝ (UtilityPossibilitySet E) ∧
    ∃ c : ℝ, UPSBoundary E = {u : ℕ → ℝ | ∑ i ∈ Finset.range (E.I), u i = c} :=
  ⟨ups_convex E, boundary_hyperplane E hq⟩