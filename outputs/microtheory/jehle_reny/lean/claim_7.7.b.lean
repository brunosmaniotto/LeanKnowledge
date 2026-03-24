import Mathlib

/-- Expected payoffs in the sophisticated matching pennies game (MWG Claim 7.7.b).
    Direct calculation using game tree payoffs and Bayes' rule beliefs (E.1)
    with x + x̄ = y + ȳ = 1 (no quitting). -/
theorem Claim_7_7_b (x xb y yb zβ zγ : ℝ)
    (hx : x + xb = 1) (hy : y + yb = 1)
    (hβ : x * yb + y * xb ≠ 0) (hγ : x * y + xb * yb ≠ 0) :
    -- v₁(H|I₁) = 4 − 8(yzγ + ȳzβ)
    y * (-4 * zγ + 4 * (1 - zγ)) + yb * (-4 * zβ + 4 * (1 - zβ)) =
      4 - 8 * (y * zγ + yb * zβ) ∧
    -- v₁(T|I₁) = −4 + 8(yzβ + ȳzγ)
    y * (4 * zβ - 4 * (1 - zβ)) + yb * (4 * zγ - 4 * (1 - zγ)) =
      -4 + 8 * (y * zβ + yb * zγ) ∧
    -- v₂(H|I₂)
    x * (2 * zγ - 2 * (1 - zγ)) + xb * (-2 * zβ + 2 * (1 - zβ)) =
      4 * (x * zγ - xb * zβ) + 2 * (xb - x) ∧
    -- v₂(T|I₂)
    x * (2 * zβ - 2 * (1 - zβ)) + xb * (-2 * zγ + 2 * (1 - zγ)) =
      4 * (x * zβ - xb * zγ) + 2 * (xb - x) ∧
    -- Bayes beliefs at I₃β sum to 1
    x * yb / (x * yb + y * xb) + y * xb / (x * yb + y * xb) = 1 ∧
    -- Bayes beliefs at I₃γ sum to 1
    x * y / (x * y + xb * yb) + xb * yb / (x * y + xb * yb) = 1 ∧
    -- v₃(H|I₃β) = 2(xȳ − yx̄)/(xȳ + yx̄)
    x * yb / (x * yb + y * xb) * 2 + y * xb / (x * yb + y * xb) * (-2) =
      2 * (x * yb - y * xb) / (x * yb + y * xb) ∧
    -- v₃(T|I₃β) = 2(yx̄ − xȳ)/(xȳ + yx̄)
    x * yb / (x * yb + y * xb) * (-2) + y * xb / (x * yb + y * xb) * 2 =
      2 * (y * xb - x * yb) / (x * yb + y * xb) ∧
    -- v₃(H|I₃γ) = 2(xy − x̄ȳ)/(xy + x̄ȳ)
    x * y / (x * y + xb * yb) * 2 + xb * yb / (x * y + xb * yb) * (-2) =
      2 * (x * y - xb * yb) / (x * y + xb * yb) ∧
    -- v₃(T|I₃γ) = 2(x̄ȳ − xy)/(xy + x̄ȳ)
    x * y / (x * y + xb * yb) * (-2) + xb * yb / (x * y + xb * yb) * 2 =
      2 * (xb * yb - x * y) / (x * y + xb * yb) := by
  have hyb : yb = 1 - y := by linarith
  have hxb : xb = 1 - x := by linarith
  subst hyb; subst hxb
  refine ⟨by ring, by ring, by ring, by ring, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · field_simp
  · field_simp
  · field_simp; ring
  · field_simp; ring
  · field_simp; ring
  · field_simp; ring