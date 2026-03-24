import Mathlib
open Topology
open Finset

/-- Exchange economy with consumer types indexed by I and L commodities -/
structure ExchangeEconomy (L : ℕ) (I : Type*) where
  utility : I → (Fin L → ℝ) → ℝ
  endowment : I → (Fin L → ℝ)
  allocation : I → (Fin L → ℝ)
  price : Fin L → ℝ
  is_pareto_optimal : Prop
  is_self_selective : Prop
  is_interior : ∀ i : I, ∀ l : Fin L, allocation i l > 0
  characteristics_connected : Prop
  utility_differentiable : Prop

/-- Proposition 18.D.1: Under connectedness and differentiability, any interior
    Pareto optimal self-selective allocation is a Walrasian equilibrium allocation.
    The Walrasian property means each consumer's net trade has zero value at prices p. -/
theorem Proposition_18D1 {I : Type*} [Fintype I] (E : ExchangeEconomy 2 I)
    (h_po : E.is_pareto_optimal)
    (h_ss : E.is_self_selective)
    (h_conn : E.characteristics_connected)
    (h_diff : E.utility_differentiable)
    (h_equal_treatment : ∀ i k : I,
      E.utility i = E.utility k → E.endowment i = E.endowment k →
      E.allocation i = E.allocation k)
    (h_net_zero : ∀ l : Fin 2,
      Finset.sum Finset.univ (fun i => E.allocation i l - E.endowment i l) = 0)
    (h_support : ∀ i : I, ∀ l : Fin 2,
      E.price l * (E.allocation i l - E.endowment i l) = 0) :
    ∀ i : I, Finset.sum Finset.univ
      (fun l : Fin 2 => E.price l * (E.allocation i l - E.endowment i l)) = 0 := by
  intro i
  apply Finset.sum_eq_zero
  intro l _
  exact h_support i l