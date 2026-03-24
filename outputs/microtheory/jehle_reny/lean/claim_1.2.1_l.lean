import Mathlib
open Topology

/-- Under strict monotonicity, points north-east of x⁰ are strictly preferred to x⁰,
    and points south-west of x⁰ are strictly less preferred than x⁰. -/
theorem Claim_1_2_1_l
    {n : ℕ} [NeZero n]
    (strictPref : (Fin n → ℝ) → (Fin n → ℝ) → Prop)
    (strict_mono : ∀ x y : Fin n → ℝ, (∀ i, x i < y i) → strictPref y x)
    (x0 x1 x2 : Fin n → ℝ)
    (h1 : ∀ i, x0 i < x1 i)
    (h2 : ∀ i, x2 i < x0 i) :
    strictPref x1 x0 ∧ strictPref x0 x2 :=
  ⟨strict_mono x0 x1 h1, strict_mono x2 x0 h2⟩