import Mathlib

/-- Region II cannot be socially indifferent to ū: if W were constant on a set
    containing a Pareto-dominating pair, the Weak Pareto Principle is violated. -/
theorem Claim_6_2_1_i
    (W : (Fin 2 → ℝ) → ℝ)
    -- Weak Pareto: strict component-wise dominance ⟹ strictly higher welfare
    (hWP : ∀ v w : Fin 2 → ℝ, (∀ i, w i < v i) → W v > W w)
    -- Region II contains two points with one Pareto-dominating the other
    (S : Set (Fin 2 → ℝ))
    (v w : Fin 2 → ℝ)
    (hv : v ∈ S) (hw : w ∈ S)
    (hdom : ∀ i, w i < v i)
    -- All points in S are socially indifferent (W constant on S)
    (hconst : ∀ a b : Fin 2 → ℝ, a ∈ S → b ∈ S → W a = W b)
    : False := by
  have heq := hconst v w hv hw
  have hlt := hWP v w hdom
  linarith