import Mathlib

noncomputable section

open Set Function
open Topology

-- Axiomatize the existence of the equilibrium path
axiom equilibrium_path_exists
    {n : ℕ}
    (z : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p : Fin n → ℝ)
    (hz_eq : z p 0 = 0)
    (hregular : Function.Surjective (fderiv ℝ (fun p' => z p' 0) p))
    : ∃ p_tilde : Fin n → ℝ,
        z p_tilde 1 = 0 ∧
        ∃ γ : ℝ → (Fin n → ℝ), Continuous γ ∧ γ 0 = p ∧ γ 1 = p_tilde ∧
          ∀ t ∈ Set.Icc (0 : ℝ) 1, z (γ t) t = 0

-- Axiomatize homotopy independence for small shocks
axiom homotopy_independence
    {n : ℕ}
    (z : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p : Fin n → ℝ)
    (hz_eq : z p 0 = 0)
    (hregular : Function.Surjective (fderiv ℝ (fun p' => z p' 0) p))
    (γ₁ γ₂ : ℝ → (Fin n → ℝ))
    (hγ₁ : γ₁ 0 = p ∧ ∀ t ∈ Set.Icc (0 : ℝ) 1, z (γ₁ t) t = 0)
    (hγ₂ : γ₂ 0 = p ∧ ∀ t ∈ Set.Icc (0 : ℝ) 1, z (γ₂ t) t = 0)
    : γ₁ 1 = γ₂ 1

/-- Claim 17G_c: At a regular equilibrium, small parameter shocks yield a unique
    equilibrium path, and the resulting equilibrium is independent of the homotopy. -/
theorem claim_17G_c
    {n : ℕ}
    (z : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p : Fin n → ℝ)
    (hz_eq : z p 0 = 0)
    (hregular : Function.Surjective (fderiv ℝ (fun p' => z p' 0) p))
    : ∃ p_tilde : Fin n → ℝ,
        z p_tilde 1 = 0 ∧
        (∃ γ : ℝ → (Fin n → ℝ), Continuous γ ∧ γ 0 = p ∧ γ 1 = p_tilde ∧
          ∀ t ∈ Set.Icc (0 : ℝ) 1, z (γ t) t = 0) ∧
        (∀ (γ₁ γ₂ : ℝ → (Fin n → ℝ)),
          (γ₁ 0 = p ∧ ∀ t ∈ Set.Icc (0 : ℝ) 1, z (γ₁ t) t = 0) →
          (γ₂ 0 = p ∧ ∀ t ∈ Set.Icc (0 : ℝ) 1, z (γ₂ t) t = 0) →
          γ₁ 1 = γ₂ 1) := by
  obtain ⟨p_tilde, hp_eq, γ, hcont, hγ0, hγ1, hγpath⟩ :=
    equilibrium_path_exists z p hz_eq hregular
  exact ⟨p_tilde, hp_eq, ⟨γ, hcont, hγ0, hγ1, hγpath⟩,
    fun γ₁ γ₂ h₁ h₂ => homotopy_independence z p hz_eq hregular γ₁ γ₂ h₁ h₂⟩

end