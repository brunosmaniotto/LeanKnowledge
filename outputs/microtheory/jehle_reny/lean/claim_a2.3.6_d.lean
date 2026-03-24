import Mathlib

/-- The slope of a vector (z₁, z₂) is z₂/z₁. Applied to gradient vectors,
    the slope of ∇g(x*) = (∂g/∂x₁, ∂g/∂x₂) is (∂g/∂x₂)/(∂g/∂x₁). -/
theorem gradient_slope_is_component_ratio
    (dg1_dx1 dg1_dx2 df_dx1 df_dx2 dg2_dx1 dg2_dx2 : ℝ) :
    -- The slope of ∇g₁(x*) = (dg1_dx1, dg1_dx2) is dg1_dx2 / dg1_dx1
    let slope_g1 := dg1_dx2 / dg1_dx1
    -- The slope of ∇f(x*) = (df_dx1, df_dx2) is df_dx2 / df_dx1
    let slope_f := df_dx2 / df_dx1
    -- The slope of ∇g₂(x*) = (dg2_dx1, dg2_dx2) is dg2_dx2 / dg2_dx1
    let slope_g2 := dg2_dx2 / dg2_dx1
    slope_g1 = dg1_dx2 / dg1_dx1 ∧
    slope_f = df_dx2 / df_dx1 ∧
    slope_g2 = dg2_dx2 / dg2_dx1 := by
  exact ⟨rfl, rfl, rfl⟩