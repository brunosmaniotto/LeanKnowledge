import Mathlib

noncomputable section

/-- An insurance policy (benefit, premium). -/
structure Policy where
  benefit : ℝ
  premium : ℝ

/-- Rothschild-Stiglitz insurance model with key equilibrium properties. -/
structure RSModel where
  u_l : Policy → ℝ
  u_h : Policy → ℝ
  ψ_c_h : Policy
  ψ_bar_l : Policy
  onLowLine : Policy → Prop
  onHighLine : Policy → Prop
  /-- ψ^c_h maximizes u_h on the high-risk zero-profit line -/
  max_high : ∀ ψ, onHighLine ψ → u_h ψ ≤ u_h ψ_c_h
  /-- ψ^c_h is the unique maximizer (strict concavity) -/
  max_high_unique : ∀ ψ, onHighLine ψ → u_h ψ = u_h ψ_c_h → ψ = ψ_c_h
  /-- ψ̄_l maximizes u_l on the low-risk line subject to high-risk IC -/
  bar_l_optimal : ∀ ψ, onLowLine ψ → u_h ψ ≤ u_h ψ_c_h → u_l ψ ≤ u_l ψ_bar_l
  /-- ψ̄_l is the unique constrained maximizer -/
  bar_l_unique : ∀ ψ, onLowLine ψ → u_h ψ ≤ u_h ψ_c_h →
    u_l ψ = u_l ψ_bar_l → ψ = ψ_bar_l

/-- Pure strategy separating equilibrium with Claims 1–2 established. -/
structure SepEq (M : RSModel) where
  ψ_l : Policy
  ψ_h : Policy
  /-- Claim 1: u_h(ψ*_h) ≥ u_h(ψ^c_h) -/
  h_utility_lb : M.u_h M.ψ_c_h ≤ M.u_h ψ_h
  /-- Claim 2: ψ*_l lies on the low-risk zero-profit line -/
  l_on_low : M.onLowLine ψ_l
  /-- ψ*_h lies on the high-risk zero-profit line (from Claims 1–2 + Lemma 8.2) -/
  h_on_high : M.onHighLine ψ_h
  /-- IC: high-risk weakly prefers own contract -/
  h_prefers_h : M.u_h ψ_l ≤ M.u_h ψ_h
  /-- Equilibrium optimality: low-risk at least as well off as at ψ̄_l -/
  l_at_least_bar : M.u_l M.ψ_bar_l ≤ M.u_l ψ_l

/-- **Theorem 8.5** (Rothschild-Stiglitz): In a pure strategy separating equilibrium,
    ψ*_h = ψ^c_h (full insurance at fair rate) and ψ*_l = ψ̄_l (constrained optimum). -/
theorem Theorem_8_5 (M : RSModel) (E : SepEq M) :
    E.ψ_h = M.ψ_c_h ∧ E.ψ_l = M.ψ_bar_l := by
  constructor
  · -- Claim 3: ψ*_h = ψ^c_h
    -- u_h(ψ_h) ≤ u_h(ψ_c_h) from max_high, u_h(ψ_h) ≥ u_h(ψ_c_h) from Claim 1
    have heq : M.u_h E.ψ_h = M.u_h M.ψ_c_h :=
      le_antisymm (M.max_high E.ψ_h E.h_on_high) E.h_utility_lb
    exact M.max_high_unique E.ψ_h E.h_on_high heq
  · -- Claim 4: ψ*_l = ψ̄_l
    -- First establish u_h(ψ_l) ≤ u_h(ψ_c_h) using IC + Claim 3
    have heq_h : M.u_h E.ψ_h = M.u_h M.ψ_c_h :=
      le_antisymm (M.max_high E.ψ_h E.h_on_high) E.h_utility_lb
    have hIC : M.u_h E.ψ_l ≤ M.u_h M.ψ_c_h := by
      calc M.u_h E.ψ_l ≤ M.u_h E.ψ_h := E.h_prefers_h
        _ = M.u_h M.ψ_c_h := heq_h
    -- u_l(ψ_l) ≤ u_l(ψ̄_l) from bar_l_optimal, u_l(ψ_l) ≥ u_l(ψ̄_l) from optimality
    have heq_l : M.u_l E.ψ_l = M.u_l M.ψ_bar_l :=
      le_antisymm (M.bar_l_optimal E.ψ_l E.l_on_low hIC) E.l_at_least_bar
    exact M.bar_l_unique E.ψ_l E.l_on_low hIC heq_l