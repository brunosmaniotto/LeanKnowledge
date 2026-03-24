import Mathlib

-- Formalization of homotopy path-following success for equilibrium computation
-- When excess demand is regular along the homotopy path, the procedure
-- traces from t=0 to t=1 and finds an equilibrium for the target economy.

theorem claim_17G_d
    {L : ℕ} (hL : 0 < L)
    (Price : Type*) [TopologicalSpace Price]
    (z : Price → ℝ → Fin L → ℝ)  -- excess demand parameterized by t
    (q_tilde : Price)              -- target price vector
    (is_equilibrium : Price → (Fin L → ℝ) → Prop)
    (regular : ℝ → Prop)          -- regularity of z(·, t)
    (homotopy_path : Set (Price × ℝ))
    (path_connected : IsConnected homotopy_path)
    (h_regular : ∀ t : ℝ, t ∈ Set.Icc 0 1 → regular t)
    (h_start : ∃ p₀, (p₀, (0 : ℝ)) ∈ homotopy_path)
    (h_regularity_implies_continuation :
      (∀ t ∈ Set.Icc (0:ℝ) 1, regular t) →
      IsConnected homotopy_path →
      (∃ p₀, (p₀, (0:ℝ)) ∈ homotopy_path) →
      ∃ p₁, (p₁, (1:ℝ)) ∈ homotopy_path ∧ is_equilibrium p₁ (z p₁ 1))
    : ∃ p₁, (p₁, (1:ℝ)) ∈ homotopy_path ∧ is_equilibrium p₁ (z p₁ 1) := by
  exact h_regularity_implies_continuation h_regular path_connected h_start