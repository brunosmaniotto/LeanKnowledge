# Category Supplement: Real Analysis & Calculus

## Key imports
```lean
import Mathlib
open Filter Topology Real
```

## Core types
```
-- Limits and filters
Filter.Tendsto f l₁ l₂  — f converges along filter l₁ to l₂
Filter.atTop             — filter at infinity for ℕ, ℤ, ℝ
nhds a                   — neighborhood filter of a

-- Continuity
Continuous f             — f is continuous
ContinuousAt f a         — f is continuous at a
ContinuousOn f s         — f is continuous on set s

-- Differentiability
HasDerivAt f f' a        — f has derivative f' at a
Differentiable ℝ f       — f is differentiable
deriv f a                — the derivative of f at a

-- Integration
intervalIntegral.integral : ∫ x in a..b, f x  — integral on [a,b]
MeasureTheory.integral    : ∫ x, f x ∂μ       — Lebesgue integral
```

## Key lemmas
```
-- Limits
Filter.Tendsto.add     : tendsto + tendsto → tendsto of sum
Filter.Tendsto.mul     : tendsto * tendsto → tendsto of product
tendsto_const_nhds     : constant function converges to that constant
squeeze_zero           : squeeze theorem for sequences

-- Continuity
Continuous.add, .mul, .sub, .div, .comp — continuity of arithmetic
continuous_id          : id is continuous
continuous_const       : constant is continuous

-- Derivatives
HasDerivAt.add, .mul, .sub, .comp — derivative rules
hasDerivAt_id          : d/dx(x) = 1
hasDerivAt_const       : d/dx(c) = 0
HasDerivAt.pow         : power rule

-- Sequences and series
summable_geometric_of_lt_one : |r| < 1 → Summable (fun n => r ^ n)
tsum_geometric_of_lt_one     : sum of geometric series
```

## Notation
- `𝓝 a` — neighborhood filter of `a` (with `open Topology`)
- `atTop` — filter at infinity (with `open Filter`)
- `∫ x in a..b, f x` — interval integral
- `∑' n, f n` — infinite sum (tsum)
- `f →[l] a` — `Tendsto f l (nhds a)` shorthand (sometimes)

## Common pitfalls
1. **Filter-based limits**: Lean uses filters, not epsilon-delta. Express `limₙ→∞ aₙ = L` as `Tendsto a atTop (nhds L)`.
2. **`nhds` vs `𝓝`**: They are the same. `𝓝 a` is notation for `nhds a` (needs `open Topology`).
3. **Real.sqrt domain**: `Real.sqrt` is total (returns 0 for negative inputs). No need for domain hypothesis.
4. **Sums vs series**: `∑ i ∈ Finset.range n, f i` is a finite sum. `∑' n, f n` (tsum) is an infinite series.
5. **`norm_num` + `positivity`**: Good combination for proving bounds and positivity in analysis.

## Worked example: Limit of 1/n → 0
```lean
import Mathlib
open Filter Topology

theorem tendsto_inv_atTop :
    Tendsto (fun n : ℕ => (1 : ℝ) / (n + 1)) atTop (nhds 0) := by
  rw [show (0 : ℝ) = 1 / 0 from by simp]
  exact tendsto_const_div_atTop_nhds_0_nat 1
```
