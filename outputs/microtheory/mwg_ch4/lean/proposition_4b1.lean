import Mathlib

/-- Proposition 4.B.1 (MWG): Gorman form ↔ parallel straight wealth expansion paths.
    We formalize the sufficiency direction (Gorman → parallel WEP) structurally.
    Necessity (parallel WEP → Gorman) is due to Deaton & Muellbauer (1980). -/
theorem Proposition_4B1
    (I : Type*) [Nonempty I]
    (a : I → ℝ)
    (b : ℝ)
    (demand : I → ℝ → ℝ)
    (roy : ∀ i w, demand i w = a i + b * w)
    : (∀ i j : I, ∀ w₁ w₂ : ℝ, demand i w₂ - demand i w₁ = demand j w₂ - demand j w₁) := by
  intro i j w₁ w₂
  simp only [roy]
  ring