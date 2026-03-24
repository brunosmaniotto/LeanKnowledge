import Mathlib

open Topology

theorem has_sum_linear_combination (a b : ℕ → ℝ) (α β lam mu : ℝ)
    (ha : HasSum (fun n => a (n + 1)) α) (hb : HasSum (fun n => b (n + 1)) β) :
    HasSum (fun n => lam * a (n + 1) + mu * b (n + 1)) (lam * α + mu * β) :=
  (ha.const_smul lam).add (hb.const_smul mu)