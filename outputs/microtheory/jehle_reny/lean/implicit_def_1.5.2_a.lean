import Mathlib

open scoped Classical
open Topology

/-- The Hicksian (compensated) demand function.
    `hicksianDemand p u l` returns the quantity of good `l` demanded
    when prices are `p` and the consumer is held at utility level `u`. -/
axiom hicksianDemand {n : ℕ} (p : Fin n → ℝ) (u : ℝ) (l : Fin n) : ℝ

/-- The substitution effect (Hicksian decomposition) of a price change from `p₀` to `p₁`
    on good `l`, holding utility constant at `u₀`:
      SE_l = h_l(p₁, u₀) − h_l(p₀, u₀)
    where `h` is the Hicksian (compensated) demand function. -/
noncomputable def substitutionEffect {n : ℕ} (p₀ p₁ : Fin n → ℝ) (u₀ : ℝ) (l : Fin n) : ℝ :=
  hicksianDemand p₁ u₀ l - hicksianDemand p₀ u₀ l