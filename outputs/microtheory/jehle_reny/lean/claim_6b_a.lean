import Mathlib
open Topology

theorem Claim_6B_a
    (W : ℝ → ℝ → ℝ)
    (hinv : ∀ (ψ₁ ψ₂ : ℝ → ℝ), StrictMono ψ₁ → StrictMono ψ₂ →
      ∀ a₁ a₂ b₁ b₂, W a₁ a₂ < W b₁ b₂ ↔ W (ψ₁ a₁) (ψ₂ a₂) < W (ψ₁ b₁) (ψ₂ b₂))
    (hne : ∀ a₁ a₂, W a₁ a₂ ≠ W (a₁ - 1) (a₂ + 1))
    (ū₁ ū₂ : ℝ) :
    (W (ū₁ + 1) (ū₂ - 1) < W ū₁ ū₂ ∧ W ū₁ ū₂ < W (ū₁ - 1) (ū₂ + 1)) ∨
    (W (ū₁ - 1) (ū₂ + 1) < W ū₁ ū₂ ∧ W ū₁ ū₂ < W (ū₁ + 1) (ū₂ - 1)) := by
  have hm₁ : StrictMono (fun x : ℝ => x + 1) := fun _ _ h => by linarith
  have hm₂ : StrictMono (fun x : ℝ => x - 1) := fun _ _ h => by linarith
  -- Key: W(ū) < W(NW) ↔ W(SE) < W(ū) via ψ₁=(·+1), ψ₂=(·-1)
  have key : W ū₁ ū₂ < W (ū₁ - 1) (ū₂ + 1) ↔ W (ū₁ + 1) (ū₂ - 1) < W ū₁ ū₂ := by
    have h := hinv (· + 1) (· - 1) hm₁ hm₂ ū₁ ū₂ (ū₁ - 1) (ū₂ + 1)
    have e1 : ū₁ - 1 + 1 = ū₁ := by ring
    have e2 : ū₂ + 1 - 1 = ū₂ := by ring
    rw [e1, e2] at h; exact h
  -- W(ū) ≠ W(SE), derived from hne at the shifted point
  have hne_se : W ū₁ ū₂ ≠ W (ū₁ + 1) (ū₂ - 1) := by
    have h0 := hne (ū₁ + 1) (ū₂ - 1)
    have e1 : ū₁ + 1 - 1 = ū₁ := by ring
    have e2 : ū₂ - 1 + 1 = ū₂ := by ring
    rw [e1, e2] at h0; exact Ne.symm h0
  by_cases h : W ū₁ ū₂ < W (ū₁ - 1) (ū₂ + 1)
  · exact Or.inl ⟨key.mp h, h⟩
  · have hgt : W (ū₁ - 1) (ū₂ + 1) < W ū₁ ū₂ :=
      lt_of_le_of_ne (not_lt.mp h) (Ne.symm (hne ū₁ ū₂))
    have hse : W ū₁ ū₂ < W (ū₁ + 1) (ū₂ - 1) :=
      lt_of_le_of_ne (not_lt.mp (mt key.mpr (not_lt.mpr hgt.le))) hne_se
    exact Or.inr ⟨hgt, hse⟩