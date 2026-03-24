import Mathlib

/-
Signaling game separating equilibrium: education levels between ê and ê₁.

We model:
- θ_H, θ_L: productivity/wage of high and low types (θ_H > θ_L > 0)
- c(e, θ): cost of education e for type θ, decreasing in θ (single-crossing)
- ê: defined by θ_H - c(ê, θ_L) = θ_L  (low type indifferent)
- ê₁: defined by θ_H - c(ê₁, θ_H) = θ_L  (high type indifferent)

We prove: for any e ∈ [ê, ê₁], both IC constraints hold.
-/

theorem separating_equilibrium_education_range
    (θ_H θ_L : ℝ)
    (hHL : θ_H > θ_L)
    (hL_pos : θ_L > 0)
    -- cost function: education level → type → cost (ℝ → ℝ → ℝ)
    (c : ℝ → ℝ → ℝ)
    -- cost is nonneg
    (hc_nonneg : ∀ e θ, 0 ≤ c e θ)
    -- single crossing: cost is monotone decreasing in ability (higher type has lower cost)
    (hc_mono_type : ∀ e, c e θ_H ≤ c e θ_L)
    -- cost is monotone increasing in education
    (hc_mono_ed : ∀ e₁ e₂ θ, e₁ ≤ e₂ → c e₁ θ ≤ c e₂ θ)
    -- ê and ê₁: the threshold education levels
    (ê ê₁ : ℝ)
    -- defining equations
    (h_ehat : c ê θ_L = θ_H - θ_L)
    (h_ehat1 : c ê₁ θ_H = θ_H - θ_L)
    -- ê ≤ ê₁ (follows from single-crossing, but we take it as given for clarity)
    (h_le : ê ≤ ê₁)
    -- e is any education level in [ê, ê₁]
    (e : ℝ)
    (he_lo : ê ≤ e)
    (he_hi : e ≤ ê₁) :
    -- IC for low type: low type prefers no education (wage θ_L) to mimicking (wage θ_H - cost)
    -- i.e., θ_L ≥ θ_H - c(e, θ_L), equivalently c(e, θ_L) ≥ θ_H - θ_L
    (θ_H - c e θ_L ≤ θ_L) ∧
    -- IC for high type: high type prefers education e (wage θ_H - cost) to no education (wage θ_L)
    -- i.e., θ_H - c(e, θ_H) ≥ θ_L, equivalently c(e, θ_H) ≤ θ_H - θ_L
    (θ_L ≤ θ_H - c e θ_H) := by
  constructor
  · -- Low type IC: c(e, θ_L) ≥ c(ê, θ_L) = θ_H - θ_L, so θ_H - c(e,θ_L) ≤ θ_L
    have h1 : c ê θ_L ≤ c e θ_L := hc_mono_ed ê e θ_L he_lo
    linarith
  · -- High type IC: c(e, θ_H) ≤ c(ê₁, θ_H) = θ_H - θ_L, so θ_H - c(e,θ_H) ≥ θ_L
    have h2 : c e θ_H ≤ c ê₁ θ_H := hc_mono_ed e ê₁ θ_H he_hi
    linarith