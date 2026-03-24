import Mathlib

/-- When good 1 is normal, EV > CV; when inferior, EV < CV;
    when there is no wealth effect, EV = CV.
    We formalize the no-wealth-effect case: if Hicksian demand equals
    Walrasian demand (which equals Hicksian at the new utility),
    then the two welfare integrals coincide, so CV = EV. -/
theorem claim_3Ic
    (EV CV : ℝ)
    (h₀ h₁ x₁ : ℝ → ℝ)
    (p0 p1 : ℝ)
    (hp : p0 ≤ p1)
    -- No wealth effect: Hicksian at u⁰ = Walrasian = Hicksian at u¹
    (hno_wealth : ∀ p, h₀ p = x₁ p ∧ x₁ p = h₁ p)
    -- EV is the integral of h₁ (Hicksian at u¹)
    (hEV : EV = ∫ p in Set.Icc p0 p1, h₁ p)
    -- CV is the integral of h₀ (Hicksian at u⁰)
    (hCV : CV = ∫ p in Set.Icc p0 p1, h₀ p)
    : EV = CV := by
  subst hEV; subst hCV
  congr 1
  ext p
  obtain ⟨left, right⟩ := hno_wealth p
  linarith