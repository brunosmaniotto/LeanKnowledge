import Mathlib

variable {A : Type*} [MetricSpace A]

-- The topology induced by the metric is already defined as:
--   `MetricSpace.toUniformSpace` → `UniformSpace.toTopologicalSpace`
-- This instance automatically satisfies all topological space axioms.

-- We can state and prove that this is indeed a topological space: