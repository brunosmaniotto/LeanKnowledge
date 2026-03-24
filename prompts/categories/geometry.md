# Category Supplement: Geometry

## Key imports
```lean
import Mathlib
open EuclideanGeometry InnerProductSpace
```

## Important note
Euclidean geometry in Mathlib is sparse compared to other areas. Many "geometric" results are best stated algebraically and proved with algebraic tactics.

## Core types
```
EuclideanSpace ℝ (Fin n) — n-dimensional Euclidean space
InnerProductSpace ℝ E    — real inner product space (more general)
dist : α → α → ℝ         — distance function (from MetricSpace)
inner : E → E → ℝ        — inner product (⟪x, y⟫)
‖x‖                       — norm (from NormedSpace)
```

## Key lemmas
```
-- Distance
dist_comm : dist x y = dist y x
dist_self : dist x x = 0
dist_nonneg : 0 ≤ dist x y
dist_triangle : dist x z ≤ dist x y + dist y z

-- Inner product
inner_self_eq_norm_sq : ⟪x, x⟫_ℝ = ‖x‖ ^ 2
real_inner_comm : ⟪x, y⟫_ℝ = ⟪y, x⟫_ℝ
inner_add_left : ⟪x + y, z⟫ = ⟪x, z⟫ + ⟪y, z⟫

-- Norm
norm_nonneg : 0 ≤ ‖x‖
norm_sq_eq_inner : ‖x‖ ^ 2 = ⟪x, x⟫_ℝ
```

## Recommended approach: Coordinate geometry
For most geometry problems, translate to coordinates and use algebraic tactics:

1. **Work in `ℝ × ℝ`** (2D) or `EuclideanSpace ℝ (Fin n)` (n-D)
2. **Express geometric facts algebraically**: distance = `Real.sqrt ((x₂-x₁)^2 + (y₂-y₁)^2)`
3. **Prove with `ring`, `nlinarith`, `norm_num`** after algebraic translation

## Common pitfalls
1. **Don't look for named theorems**: Most classical geometry theorems (Pythagorean, angle bisector, etc.) are NOT named lemmas in Mathlib. Prove them from scratch using algebra.
2. **Angles**: The `EuclideanGeometry.angle` function exists but is limited. For angle proofs, use inner products: `cos θ = ⟪u, v⟫ / (‖u‖ * ‖v‖)`.
3. **Avoid over-abstraction**: Don't try to define "triangle" or "circle" as types. Work with points and distances directly.
4. **Use `nlinarith`**: Very powerful for polynomial inequalities that arise from geometric problems.

## Worked example: Triangle inequality for distance
```lean
import Mathlib

theorem triangle_ineq {α : Type*} [PseudoMetricSpace α] (a b c : α) :
    dist a c ≤ dist a b + dist b c :=
  dist_triangle a b c
```
