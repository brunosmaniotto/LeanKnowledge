import Mathlib
open Topology

/-- A vector `z` indexed by commodity `(h, t)` and state `s` is measurable with
respect to information partitions `F` if whenever two states `s, s'` belong to
the same partition element at time `t`, the values agree:
`F t s = F t s'` → `z (h, t) s = z (h, t) s'`.

Here `H` is the number of basic commodities, `T + 1` is the number of dates,
and `S` is the number of states. -/
def IsInfoMeasurable
    (H : ℕ) (T : ℕ) (S : ℕ)
    (F : Fin (T + 1) → Fin S → ℕ)
    (z : Fin H × Fin (T + 1) → Fin S → ℝ) : Prop :=
  ∀ (h : Fin H) (t : Fin (T + 1)) (s s' : Fin S),
    F t s = F t s' →
    z (h, t) s = z (h, t) s'