import Mathlib

/-- **Claim 1(a)**: As θ increases in multiplier preferences
    V(f) = min_p [∫ u(f) dp + θ·R(p ‖ q)], the minimizing prior p*
    concentrates toward q (its divergence R(p* ‖ q) decreases).

    Formalized as a parametric optimization result: if x₁ minimizes
    f(x) + θ₁·g(x) and x₂ minimizes f(x) + θ₂·g(x) with θ₁ < θ₂,
    then g(x₂) ≤ g(x₁). Applying with g = R(·‖q) gives the claim. -/
theorem Claim_1_a
    {X : Type*} (f g : X → ℝ) {θ₁ θ₂ : ℝ} (hθ : θ₁ < θ₂)
    {x₁ x₂ : X}
    (hmin₁ : ∀ x, f x₁ + θ₁ * g x₁ ≤ f x + θ₁ * g x)
    (hmin₂ : ∀ x, f x₂ + θ₂ * g x₂ ≤ f x + θ₂ * g x) :
    g x₂ ≤ g x₁ := by
  by_contra hc
  push_neg at hc
  nlinarith [hmin₁ x₂, hmin₂ x₁, mul_pos (sub_pos.mpr hθ) (sub_pos.mpr hc)]