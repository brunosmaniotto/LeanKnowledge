# Category Supplement: Trigonometry

## Key imports
```lean
import Mathlib
open Real
```

## Core functions (all in `Real` namespace)
```
Real.sin : ℝ → ℝ
Real.cos : ℝ → ℝ
Real.tan : ℝ → ℝ
Real.arcsin : ℝ → ℝ
Real.arccos : ℝ → ℝ
Real.arctan : ℝ → ℝ
Real.exp : ℝ → ℝ
Real.log : ℝ → ℝ
Real.pi : ℝ
```

## Key lemmas
```
-- Fundamental identities
Real.sin_sq_add_cos_sq : sin x ^ 2 + cos x ^ 2 = 1
Real.cos_sq_add_sin_sq : cos x ^ 2 + sin x ^ 2 = 1
Real.cos_add : cos (x + y) = cos x * cos y - sin x * sin y
Real.sin_add : sin (x + y) = sin x * cos y + cos x * sin y
Real.cos_sub : cos (x - y) = cos x * cos y + sin x * sin y
Real.sin_sub : sin (x - y) = sin x * cos y - cos x * sin y

-- Double angle
Real.cos_two_mul : cos (2 * x) = 2 * cos x ^ 2 - 1
Real.sin_two_mul : sin (2 * x) = 2 * sin x * cos x

-- Special values
Real.cos_zero : cos 0 = 1
Real.sin_zero : sin 0 = 0
Real.cos_pi : cos π = -1
Real.sin_pi : sin π = 0
Real.cos_pi_div_two : cos (π / 2) = 0
Real.sin_pi_div_two : sin (π / 2) = 1

-- Negation
Real.cos_neg : cos (-x) = cos x
Real.sin_neg : sin (-x) = -(sin x)

-- Tangent
Real.tan_eq_sin_div_cos : tan x = sin x / cos x
```

## Naming patterns
- Trig functions: `Real.<func>` (e.g., `Real.sin`, `Real.cos`)
- Identities: `Real.<func>_<property>` (e.g., `Real.cos_add`, `Real.sin_zero`)
- With `open Real`, write `sin x` instead of `Real.sin x`

## Type note
All trig functions operate on `ℝ`. There are no integer or rational versions. Everything must be cast to `ℝ` first.

## Common pitfalls
1. **Powers syntax**: Write `sin x ^ 2`, NOT `sin² x` or `sin^2 x`. Lean 4 uses `^` for powers.
2. **Parentheses**: `sin x ^ 2` means `(sin x) ^ 2`. If you mean `sin (x ^ 2)`, you need explicit parentheses.
3. **`π` constant**: Use `Real.pi` or `π` with `open Real`. Do NOT write `Float.pi` or `3.14159`.
4. **Tactic approach**: Many trig identities are best proved by `ring` after rewriting with fundamental identities, or by `simp [sin_add, cos_add, ...]`.
5. **`nlinarith`**: Useful for inequalities involving trig functions, especially combined with `sin_sq_add_cos_sq`.

## Worked example: cos²(x) = 1 - sin²(x)
```lean
import Mathlib
open Real

theorem cos_sq_eq (x : ℝ) : cos x ^ 2 = 1 - sin x ^ 2 := by
  have h := sin_sq_add_cos_sq x
  linarith
```
