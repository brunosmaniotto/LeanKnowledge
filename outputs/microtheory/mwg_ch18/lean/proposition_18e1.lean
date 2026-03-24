import Mathlib
open Topology
open BigOperators

structure ContinuumEconomy (H L : ℕ) where
  μ_bar : Fin H → ℝ
  ω : Fin H → Fin L → ℝ
  u : Fin H → (Fin L → ℝ) → ℝ
  v : (Fin H → ℝ) → ℝ
  μ_pos : ∀ h, 0 < μ_bar h

variable {H L : ℕ} [NeZero H] [NeZero L]

def ContinuumEconomy.is_feasible (E : ContinuumEconomy H L) (x : Fin H → Fin L → ℝ) : Prop :=
  ∀ l, ∑ h, E.μ_bar h * x h l ≤ ∑ h, E.μ_bar h * E.ω h l