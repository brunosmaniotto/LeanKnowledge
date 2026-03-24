import Mathlib

open BigOperators Finset
open Topology

/-- An endowment specification for an economy with consumers `I` and `L` goods.
    Each consumer i has a non-negative vector eᵢ ∈ ℝ₊ᴸ. The economy's endowment
    vector is e = (e¹, ..., eᴵ). -/
structure Endowment (I : Type*) (L : ℕ) where
  /-- Individual endowment: consumer i's vector of L goods -/
  endow : I → (Fin L → ℝ)
  /-- Non-negativity: eⁱₗ ≥ 0 for all consumers i and goods l -/
  nonneg : ∀ i l, 0 ≤ endow i l

variable {I : Type*} [Fintype I] {L : ℕ}

/-- The aggregate endowment Σ_{i∈I} eⁱ, summing individual endowments
    across all consumers for each good. -/
noncomputable def Endowment.aggregate (e : Endowment I L) : Fin L → ℝ :=
  fun l => ∑ i : I, e.endow i l