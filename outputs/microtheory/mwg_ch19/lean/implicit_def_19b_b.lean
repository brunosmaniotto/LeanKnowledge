import Mathlib

/-- A filtration capturing sequential revelation of information.
    `T` is the final date (so there are T+1 dates 0, ..., T).
    `partition t` is the information structure at date t.
    `refine` ensures that later partitions are at least as fine as earlier ones:
    once two states are distinguishable, they remain so. -/
structure SequentialInfoRevelation (Ω : Type*) where
  /-- The final time period (T+1 dates: 0, 1, ..., T) -/
  T : ℕ
  /-- The information partition at each date t ≤ T, represented as a setoid
      (equivalence relation grouping indistinguishable states) -/
  info : Fin (T + 1) → Setoid Ω
  /-- Information is never forgotten: if t₁ ≤ t₂, then the partition at t₂
      is at least as fine as at t₁ -/
  refine : ∀ (t₁ t₂ : Fin (T + 1)), (t₁ : ℕ) ≤ (t₂ : ℕ) →
    ∀ (ω₁ ω₂ : Ω), (info t₂).r ω₁ ω₂ → (info t₁).r ω₁ ω₂