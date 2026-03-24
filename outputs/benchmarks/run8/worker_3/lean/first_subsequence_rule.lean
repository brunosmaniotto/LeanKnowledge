import Mathlib
open Filter Topology

theorem first_subsequence_rule {X : Type*} [TopologicalSpace X] [T2Space X] 
    (x : ℕ → X) (h : ∃ (φ ψ : ℕ → ℕ) (hφ : StrictMono φ) (hψ : StrictMono ψ) 
    (l₁ l₂ : X) (hl : l₁ ≠ l₂), Tendsto (x ∘ φ) atTop (𝓝 l₁) ∧ Tendsto (x ∘ ψ) atTop (𝓝 l₂)) :
    ¬∃ a : X, Tendsto x atTop (𝓝 a) := by
  rintro ⟨a, ha⟩
  rcases h with ⟨φ, ψ, hφ, hψ, l₁, l₂, hl, hφ_conv, hψ_conv⟩
  have hφ_tendsto : Tendsto φ atTop atTop := hφ.tendsto_atTop
  have hψ_tendsto : Tendsto ψ atTop atTop := hψ.tendsto_atTop
  have h1 : Tendsto (x ∘ φ) atTop (𝓝 a) := ha.comp hφ_tendsto
  have h2 : Tendsto (x ∘ ψ) atTop (𝓝 a) := ha.comp hψ_tendsto
  have hl1 : l₁ = a := tendsto_nhds_unique hφ_conv h1
  have hl2 : l₂ = a := tendsto_nhds_unique hψ_conv h2
  rw [hl1, hl2] at hl
  exact hl rfl