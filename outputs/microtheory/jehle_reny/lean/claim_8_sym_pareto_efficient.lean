import Mathlib
open Topology

/-- Symmetric-information insurance: full insurance maximizes both objectives. -/
structure SymInfoInsurance where
  S : Type*
  loss : S → ℝ
  firm_profit : (S → ℝ) → ℝ
  worker_util : (S → ℝ) → ℝ
  full_ins_max_profit : ∀ B : S → ℝ, firm_profit B ≤ firm_profit loss
  full_ins_max_util : ∀ B : S → ℝ, worker_util B ≤ worker_util loss

def IsFullInsurance (M : SymInfoInsurance) (B : M.S → ℝ) : Prop :=
  ∀ s, B s = M.loss s