import Mathlib
open Topology

/-
Proposition 18.B.2: Equal Treatment in the Core

In an N-replica economy with H types, strict convexity of preferences,
and constant returns to scale in production, any core allocation must
give all consumers of the same type the same bundle.
-/

-- Economic primitives
variable {L : ℕ} -- number of goods

-- Preference relation for type h: ≿_h on ℝ^L bundles
-- We model bundles as Fin L → ℝ

def Bundle (L : ℕ) := Fin L → ℝ

variable {H N : ℕ} -- H types, N replicas

-- An allocation assigns a bundle to each type h and replica n