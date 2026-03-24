import Mathlib

/-- A basic exchange economy with `L` commodities and consumer types indexed by `I`.
    Each type has preferences (utility) and endowments, with exactly one consumer per type.
    The distinctness condition ensures that if two types share both preferences and
    endowments, they must be the same type. -/
structure BasicExchangeEconomy (L : ℕ) (I : Type*) [Fintype I] where
  /-- Utility function representing preferences for each consumer type -/
  utility : I → (Fin L → ℝ) → ℝ
  /-- Initial endowment vector for each consumer type -/
  endowment : I → (Fin L → ℝ)
  /-- Types are distinct: same preferences and same endowments implies same type -/
  type_distinct : ∀ i j : I, utility i = utility j → endowment i = endowment j → i = j