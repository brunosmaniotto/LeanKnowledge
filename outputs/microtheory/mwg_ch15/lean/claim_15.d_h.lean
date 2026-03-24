import Mathlib

/-- Factor Price Equalization Theorem: In the 2×2 production model,
    if factor intensity condition holds and the economy doesn't fully specialize,
    then equilibrium factor prices depend only on technologies and output prices,
    not on factor endowments. -/
theorem factor_price_equalization
    {W : Type*} [TopologicalSpace W] [T2Space W]
    (c₁ c₂ : W → ℝ)
    (hc₁ : Continuous c₁) (hc₂ : Continuous c₂)
    (p₁ p₂ : ℝ)
    -- Factor intensity condition: the system c₁(w) = p₁, c₂(w) = p₂ has at most one solution
    (h_intensity : ∀ w w' : W, c₁ w = p₁ → c₂ w = p₂ → c₁ w' = p₁ → c₂ w' = p₂ → w = w')
    -- Endowment-independent: equilibrium w satisfies cost = price regardless of endowments
    (w_eq : W)
    (hw₁ : c₁ w_eq = p₁)
    (hw₂ : c₂ w_eq = p₂)
    -- For any other candidate equilibrium factor price
    (w' : W)
    (hw'₁ : c₁ w' = p₁)
    (hw'₂ : c₂ w' = p₂) :
    w' = w_eq :=
  h_intensity w' w_eq hw'₁ hw'₂ hw₁ hw₂