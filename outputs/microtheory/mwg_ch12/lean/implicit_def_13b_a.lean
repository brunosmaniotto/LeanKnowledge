import Mathlib

/-- Labor market model with asymmetric information (Akerlof, 1970).
Workers differ in productivity θ ∈ [θ̲, θ̄], firms are identical and competitive
with constant returns to scale, output price normalized to 1. -/
structure LaborMarketModel where
  /-- Lower bound on worker productivity -/
  θ_lo : ℝ
  /-- Upper bound on worker productivity -/
  θ_hi : ℝ
  /-- Productivity bounds are well-ordered -/
  lo_lt_hi : θ_lo < θ_hi
  /-- Lower bound is strictly positive -/
  lo_pos : 0 < θ_lo
  /-- Total number of workers -/
  N : ℕ
  /-- At least one worker -/
  N_pos : 0 < N
  /-- Outside option (home production) for a type-θ worker -/
  r : ℝ → ℝ
  /-- A type-θ worker accepts employment iff wage ≥ r(θ) -/
  accepts : ℝ → ℝ → Prop := fun wage θ => wage ≥ r θ