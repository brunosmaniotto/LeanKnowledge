import Mathlib

open Finset BigOperators
open BigOperators

/-- A contingent commodity space with N basic goods, T dates,
    and S(t) states at each date t. A contingent commodity is
    good k indexed by date t and state history (s₁,…,sₜ). -/
structure ContingentCommoditySpace where
  N : ℕ
  T : ℕ
  S : Fin T → ℕ
  hN : 0 < N
  hT : 0 < T
  hS : ∀ t, 0 < S t

namespace ContingentCommoditySpace

/-- Number of state histories at date t: ∏_{j≤t} S(j) -/
noncomputable def numHistories (C : ContingentCommoditySpace) (t : Fin C.T) : ℕ :=
  ∏ j ∈ Finset.univ.filter (fun j : Fin C.T => j.val ≤ t.val), C.S j

/-- Total number of date-state pairs: M = ∑_t ∏_{j≤t} S(j) -/
noncomputable def M (C : ContingentCommoditySpace) : ℕ :=
  ∑ t : Fin C.T, C.numHistories t

/-- Dimension of the consumption bundle space: N · M -/
noncomputable def dim (C : ContingentCommoditySpace) : ℕ := C.N * C.M

/-- A consumption bundle is a nonneg vector in ℝ^(N·M) -/
noncomputable def ConsumptionBundle (C : ContingentCommoditySpace) : Type :=
  { x : Fin C.dim → ℝ // ∀ i, 0 ≤ x i }

end ContingentCommoditySpace