import Mathlib

open BigOperators MeasureTheory

noncomputable section

/-- Revenue Equivalence Theorem (Theorem 9.6): Two incentive-compatible direct
    selling mechanisms with the same probability assignment functions and equal
    payoffs for zero-value bidders generate the same expected revenue. -/
theorem Theorem_9_6
    {N : ℕ}
    (c_bar₁ c_bar₂ : Fin N → ℝ → ℝ)
    (p_bar : Fin N → ℝ → ℝ)
    (f : Fin N → ℝ → ℝ)
    -- IC characterization (Theorem 9.5 part ii):
    -- expected cost is determined by probability assignment and boundary value
    (h_ic₁ : ∀ i v, c_bar₁ i v = c_bar₁ i 0 + p_bar i v * v -
        ∫ x in Set.Icc 0 v, p_bar i x)
    (h_ic₂ : ∀ i v, c_bar₂ i v = c_bar₂ i 0 + p_bar i v * v -
        ∫ x in Set.Icc 0 v, p_bar i x)
    -- Zero-value bidders are indifferent between the two mechanisms
    (h_same_c0 : ∀ i, c_bar₁ i 0 = c_bar₂ i 0) :
    -- Same expected revenue
    ∑ i : Fin N, ∫ v in Set.Icc (0 : ℝ) 1, c_bar₁ i v * f i v =
    ∑ i : Fin N, ∫ v in Set.Icc (0 : ℝ) 1, c_bar₂ i v * f i v := by
  have h_eq : c_bar₁ = c_bar₂ := by
    funext i v
    rw [h_ic₁ i v, h_ic₂ i v, h_same_c0 i]
  rw [h_eq]