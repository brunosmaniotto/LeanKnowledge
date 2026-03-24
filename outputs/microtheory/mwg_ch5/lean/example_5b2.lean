import Mathlib

noncomputable def cobbDouglasProduction (α β : ℝ) (z₁ z₂ : ℝ) : ℝ :=
  z₁ ^ α * z₂ ^ β

noncomputable def cobbDouglasMRTS₁₂ (α β : ℝ) (z₁ z₂ : ℝ) : ℝ :=
  α * z₂ / (β * z₁)