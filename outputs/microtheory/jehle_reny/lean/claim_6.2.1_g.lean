import Mathlib

theorem claim_6_2_1_g
    {W : (Fin 2 → ℝ) → ℝ}
    (hWP : ∀ u v : Fin 2 → ℝ, (∀ i, u i > v i) → W u > W v)
    (ū : Fin 2 → ℝ) :
    (∀ u : Fin 2 → ℝ, (∀ i, u i > ū i) → W u > W ū) ∧
    (∀ u : Fin 2 → ℝ, (∀ i, ū i > u i) → W ū > W u) :=
  ⟨fun u hu => hWP u ū hu, fun u hu => hWP ū u hu⟩