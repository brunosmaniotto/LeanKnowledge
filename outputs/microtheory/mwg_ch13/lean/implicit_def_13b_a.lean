import Mathlib
open Topology

/-- Under asymmetric information where firms cannot observe worker productivity,
    the wage rate must be independent of a worker's type, yielding a single
    wage rate `w` for all workers. A `UniformWage` witnesses that a wage
    schedule is constant. -/
structure UniformWage (WorkerType : Type*) where
  /-- The wage schedule assigning a rate to each worker type. -/
  wage : WorkerType → ℝ
  /-- The single pooling wage rate. -/
  w : ℝ
  /-- The wage is independent of type: every worker receives `w`. -/
  uniform : ∀ θ : WorkerType, wage θ = w