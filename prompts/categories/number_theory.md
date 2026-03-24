# Category Supplement: Number Theory

## Key imports
```lean
import Mathlib
open Nat
```

## Core types and predicates
```
Nat.Prime p        — `p` is prime (a Prop, NOT Bool)
Nat.Coprime a b    — defined as `Nat.gcd a b = 1`
Nat.gcd a b        — greatest common divisor
Nat.lcm a b        — least common multiple
a ∣ b              — divisibility (`Dvd.dvd a b`)
Even n             — root namespace, NOT `Nat.isEven`
Odd n              — root namespace, NOT `Nat.isOdd`
```

## Key lemmas
```
-- Primes
Nat.Prime.dvd_mul          : p.Prime → p ∣ a * b → p ∣ a ∨ p ∣ b
Nat.Prime.eq_one_or_self_of_dvd : p.Prime → d ∣ p → d = 1 ∨ d = p
Nat.Prime.one_lt           : p.Prime → 1 < p
Nat.prime_def_minFac       : Prime p ↔ 2 ≤ p ∧ p.minFac = p
Nat.minFac_prime           : 2 ≤ n → n.minFac.Prime

-- Divisibility
Nat.dvd_antisymm           : a ∣ b → b ∣ a → a = b
Nat.dvd_refl               : a ∣ a
Nat.dvd_trans              : a ∣ b → b ∣ c → a ∣ c
Nat.eq_one_of_dvd_one      : a ∣ 1 → a = 1

-- Coprimality
Nat.Coprime.mul_dvd_of_dvd_of_dvd : Coprime a b → a ∣ n → b ∣ n → a * b ∣ n
Nat.Coprime.symm           : Coprime a b → Coprime b a

-- GCD / LCM
Nat.gcd_comm               : gcd a b = gcd b a
Nat.gcd_assoc              : gcd (gcd a b) c = gcd a (gcd b c)
Nat.lcm_comm               : lcm a b = lcm b a

-- Modular arithmetic
Nat.mod_def                : a % b = a - b * (a / b)
Nat.add_mod                : (a + b) % n = ((a % n) + (b % n)) % n
Nat.mul_mod                : (a * b) % n = ((a % n) * (b % n)) % n
Int.emod_emod_of_dvd       : for integer modular arithmetic

-- Factorial and combinatorics
Nat.factorial              : ℕ → ℕ
Nat.choose                 : ℕ → ℕ → ℕ
```

## Key tactics
- **`omega`**: Decides linear arithmetic over `ℕ` and `ℤ`. The go-to tactic for divisibility, modular arithmetic, and inequalities.
- **`norm_num`**: Evaluates concrete numerical expressions. Handles `Nat.Prime` checks for specific numbers.
- **`decide`**: For decidable propositions (e.g., `Nat.Prime 7`).

## Common pitfalls
1. **ℕ subtraction truncates!** `5 - 7 = 0` in `ℕ`. Cast to `ℤ` early if you need negative results: `(n : ℤ)`.
2. **`Nat.Prime` is NOT `Bool`**: Write `Nat.Prime p` (a Prop), not `p.isPrime` (does not exist).
3. **`Even`/`Odd` are in root namespace**: Write `Even n`, NOT `Nat.Even n` or `Nat.isEven n`.
4. **Division in ℕ is floor division**: `7 / 2 = 3` in `ℕ`. Use `ℤ` or `ℚ` for exact division.
5. **`omega` is very powerful**: It handles most goals involving `<`, `≤`, `+`, `-`, `*` (by constants), `%`, `/` over `ℕ` and `ℤ`. Try it before more complex approaches.

## Worked example: Product of two consecutive naturals is even
```lean
import Mathlib

theorem consecutive_mul_even (n : ℕ) : Even (n * (n + 1)) := by
  rcases Nat.even_or_odd n with ⟨k, hk⟩ | ⟨k, hk⟩
  · exact ⟨k * (n + 1), by omega⟩
  · exact ⟨n * (k + 1), by omega⟩
```
