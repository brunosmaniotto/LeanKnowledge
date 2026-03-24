import Mathlib

/-- A replica economy in the Debreu-Scarf framework.
    `I` indexes consumer types, `L` is the number of commodities,
    and `r` is the replication factor. The basic exchange economy has r = 1. -/
structure ReplicaEconomy (L : ℕ) (I : Type*) where
  /-- Number of replicas of each consumer type -/
  r : ℕ
  /-- At least one replica -/
  r_pos : 0 < r
  /-- Utility function representing preferences for each consumer type -/
  utility : I → (Fin L → ℝ) → ℝ
  /-- Initial endowment vector for each consumer type -/
  endowment : I → (Fin L → ℝ)

/-- The total number of consumers in a replica economy is r × |I|. -/
def ReplicaEconomy.totalConsumers [Fintype I] (E : ReplicaEconomy L I) : ℕ :=
  E.r * Fintype.card I

/-- An individual consumer is identified by type and replica index. -/
abbrev ReplicaEconomy.Consumer (E : ReplicaEconomy L I) := I × Fin E.r