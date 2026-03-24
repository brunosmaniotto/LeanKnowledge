import Mathlib
open Topology

/-- A replica economy with H types of consumers.
Each type h has preferences and endowments. The N-replica economy
has N consumers of each type, for a total of I_N = N * H consumers. -/
structure ReplicaEconomy (L : ℕ) where
  /-- Number of consumer types -/
  H : ℕ
  /-- H is positive -/
  hH : H > 0
  /-- Preference relation for each type h ∈ Fin H over commodity bundles -/
  pref : Fin H → (Fin L → ℝ) → (Fin L → ℝ) → Prop
  /-- Endowment vector for each type h ∈ Fin H -/
  endowment : Fin H → (Fin L → ℝ)
  /-- Number of replicas (N > 0) -/
  N : ℕ
  /-- N is positive -/
  hN : N > 0

namespace ReplicaEconomy

/-- Total number of consumers in the N-replica economy: I_N = N * H -/
def totalConsumers (e : ReplicaEconomy L) : ℕ := e.N * e.H

end ReplicaEconomy