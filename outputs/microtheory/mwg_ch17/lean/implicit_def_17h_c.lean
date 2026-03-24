import Mathlib
open Filter
open Topology

/-- Global stability of a Walrasian equilibrium: any price trajectory of the
tâtonnement dynamics converges to the unique equilibrium price vector. -/
noncomputable def globallyStableEquilibrium
    (n : ℕ)
    (tâtonnement : (Fin n → ℝ) → ℕ → (Fin n → ℝ))
    (p_star : Fin n → ℝ) : Prop :=
  ∀ (p₀ : Fin n → ℝ),
    Filter.Tendsto (tâtonnement p₀) Filter.atTop (nhds p_star)