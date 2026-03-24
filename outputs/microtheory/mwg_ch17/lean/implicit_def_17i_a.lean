import Mathlib

/-- An r-replica economy: an economy with I consumer types, r consumers of each type.
    An allocation assigns a consumption bundle to each type; total consumption for type i is r · xᵢ. -/
structure ReplicaEconomy (L : ℕ) where
  /-- Number of consumer types -/
  numTypes : ℕ
  /-- Number of replicas of each type -/
  replicas : ℕ
  /-- Endowment for each consumer type -/
  endowment : Fin numTypes → Fin L → ℝ
  /-- Preference relation for each consumer type (utility representation) -/
  utility : Fin numTypes → (Fin L → ℝ) → ℝ
  /-- Allocation: consumption bundle for each consumer type -/
  allocation : Fin numTypes → Fin L → ℝ