import Mathlib

open Subgroup

variable {G : Type _} [Group G]

theorem internal_direct_product_injective_iff (H₁ H₂ : Subgroup G) :
    Function.Injective (fun (p : H₁ × H₂) => (p.1 : G) * p.2) ↔ H₁ ⊓ H₂ = ⊥ := by
  set φ : H₁ × H₂ → G := fun p => (p.1 : G) * p.2 with hφ_def
  constructor
  · intro h_inj
    apply le_bot_iff.mp
    intro x hx
    rcases mem_inf.mp hx with ⟨hx1, hx2⟩
    let h1 : H₁ := ⟨x, hx1⟩
    let h2 : H₂ := ⟨x, hx2⟩
    have h_eq : φ (h1, (1 : H₂)) = φ ((1 : H₁), h2) := by
      simp [φ, h1, h2]
    have h_inj_eq := h_inj h_eq
    have h1_eq : h1 = (1 : H₁) := congr_arg Prod.fst h_inj_eq
    have : (h1 : G) = (1 : G) := congr_arg Subtype.val h1_eq
    simp [h1] at this
    exact this
  · intro h_eq
    intro p q h
    rcases p with ⟨h₁, h₂⟩
    rcases q with ⟨k₁, k₂⟩
    simp [φ] at h
    have h_mul : (h₁ : G) * h₂ = (k₁ : G) * k₂ := h
    have inner_eq : (k₁ : G)⁻¹ * h₁ = k₂ * h₂⁻¹ := by
      calc
        (k₁ : G)⁻¹ * h₁ = (k₁ : G)⁻¹ * (h₁ * 1) := by simp
        _ = (k₁ : G)⁻¹ * (h₁ * (h₂ * h₂⁻¹)) := by simp
        _ = (k₁ : G)⁻¹ * ((h₁ * h₂) * h₂⁻¹) := by group
        _ = (k₁ : G)⁻¹ * ((k₁ * k₂) * h₂⁻¹) := by rw [h_mul]
        _ = ((k₁ : G)⁻¹ * (k₁ * k₂)) * h₂⁻¹ := by group
        _ = (((k₁ : G)⁻¹ * k₁) * k₂) * h₂⁻¹ := by group
        _ = (1 * k₂) * h₂⁻¹ := by simp
        _ = k₂ * h₂⁻¹ := by simp

    have mem1 : (k₁ : G)⁻¹ * h₁ ∈ H₁ :=
      H₁.mul_mem (H₁.inv_mem k₁.2) h₁.2
    have mem2 : (k₁ : G)⁻¹ * h₁ ∈ H₂ := by
      rw [inner_eq]
      exact H₂.mul_mem k₂.2 (H₂.inv_mem h₂.2)
    have mem_inf : (k₁ : G)⁻¹ * h₁ ∈ H₁ ⊓ H₂ := ⟨mem1, mem2⟩
    rw [h_eq, mem_bot] at mem_inf
    have h1_eq : (h₁ : G) = k₁ := by
      calc
        (h₁ : G) = 1 * h₁ := by simp
        _ = ((k₁ : G) * (k₁ : G)⁻¹) * h₁ := by simp
        _ = (k₁ : G) * ((k₁ : G)⁻¹ * h₁) := by group
        _ = (k₁ : G) * 1 := by rw [mem_inf]
        _ = k₁ := by simp

    have h_inner' : (k₂ : G) * h₂⁻¹ = 1 := by rw [← inner_eq, mem_inf]
    have h2_eq : (h₂ : G) = k₂ := by
      calc
        (h₂ : G) = 1 * h₂ := by simp
        _ = ((k₂ : G) * h₂⁻¹) * h₂ := by rw [h_inner']
        _ = (k₂ : G) * (h₂⁻¹ * h₂) := by group
        _ = (k₂ : G) * 1 := by simp
        _ = k₂ := by simp

    exact Prod.ext (Subtype.ext h1_eq) (Subtype.ext h2_eq)