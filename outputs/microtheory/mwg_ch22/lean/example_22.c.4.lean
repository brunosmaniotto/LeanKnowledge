import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The constant elasticity transformation g_ρ for generalized utilitarian SWFs.
    For ρ ≠ 1: g_ρ(u) = (1 - ρ) * u^ρ
    For ρ = 1: g_ρ(u) = ln(u) -/
noncomputable def cesTransform (ρ : ℝ) (u : ℝ) : ℝ :=
  if ρ = 1 then Real.log u
  else (1 - ρ) * u ^ ρ

/-- The constant elasticity social welfare function W for a profile of utilities.
    For ρ ≠ 1: W(u) = (∑ᵢ uᵢ^(1-ρ))^(1/(1-ρ))
    For ρ = 1: W(u) = ∑ᵢ ln(uᵢ) -/
noncomputable def cesSWF {n : ℕ} (ρ : ℝ) (u : Fin n → ℝ) : ℝ :=
  if ρ = 1 then ∑ i : Fin n, Real.log (u i)
  else (∑ i : Fin n, (u i) ^ (1 - ρ)) ^ (1 / (1 - ρ))

/-- The CES representation obtained by applying h(W) = [1/(1-ρ)] W^(1/(1-ρ)) -/
noncomputable def cesRepresentation {n : ℕ} (ρ : ℝ) (u : Fin n → ℝ) : ℝ :=
  if ρ = 1 then ∑ i : Fin n, Real.log (u i)
  else (1 / (1 - ρ)) * (cesSWF ρ u) ^ (1 / (1 - ρ))