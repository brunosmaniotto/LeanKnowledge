import Mathlib
open Topology

/-- When the production function is homothetic, the proportions in which
    the firm combines any given pair of inputs is the same for every
    level of output.

    Homotheticity implies cost-minimizing input demands factor as
    z_i(w,q) = scale(w,q) · base_i(w), where base depends only on
    input prices. The ratio z_i/z_j = base_i(w)/base_j(w) is thus
    independent of the output level q. -/
theorem Exercise_3_38
    {n : ℕ}
    -- Cost-minimizing input demand: function of prices w and output q
    (z : (Fin n → ℝ) → ℝ → Fin n → ℝ)
    -- Homotheticity ⇒ demands factor into a scale and a price-only component
    (scale : (Fin n → ℝ) → ℝ → ℝ)
    (base : (Fin n → ℝ) → Fin n → ℝ)
    (homothetic_factoring : ∀ w q i, z w q i = scale w q * base w i)
    -- Fix prices, two output levels, and a pair of inputs
    (w : Fin n → ℝ) (q₁ q₂ : ℝ) (i j : Fin n)
    (hbase : base w j ≠ 0)
    (hscale1 : scale w q₁ ≠ 0)
    (hscale2 : scale w q₂ ≠ 0) :
    z w q₁ i / z w q₁ j = z w q₂ i / z w q₂ j := by
  simp only [homothetic_factoring]
  rw [div_eq_div_iff (mul_ne_zero hscale1 hbase) (mul_ne_zero hscale2 hbase)]
  ring