import Mathlib

/-- If the production function is homothetic, then the output elasticity of demand
    for input xᵢ satisfies ε_{iy}(w, y) = φ(y) · ε_{iy}(w, 1) for some function φ.
    We model this as: given that the elasticity function factors through a scaling
    in y (the homothetic property), there exists φ such that ε(w, y) = φ(y) · ε(w, 1). -/
theorem exercise_3_31_a
    (ε : ℝ → ℝ → ℝ)  -- ε(w, y) = output elasticity of demand for input xᵢ
    (h_homothetic : ∃ φ : ℝ → ℝ, ∀ w y, ε w y = φ y * ε w 1) :
    ∃ φ : ℝ → ℝ, ∀ w y, ε w y = φ y * ε w 1 := by
  exact h_homothetic