import Mathlib

open Set
open Topology
open MeasureTheory

/--
Social welfare with J active firms in a homogeneous-good industry (Implicit_Def_12E_b).

W(J) = ∫_0^{Jq_J} p(s) ds - Jc(q_J) - JK, where:
- `p` is the inverse demand function.
- `c` is the cost function.
- `K` is the entry cost.
- `q J` is the symmetric equilibrium output per firm `q_J`.
- `J` is the number of firms.
Welfare is measured by Marshallian aggregate surplus.
-/
noncomputable def socialWelfare (p c : ℝ → ℝ) (K : ℝ) (q : ℕ → ℝ) (J : ℕ) : ℝ :=
  (∫ s in Icc 0 ((J : ℝ) * q J), p s) - (J : ℝ) * c (q J) - (J : ℝ) * K