import Mathlib
open Topology

noncomputable section

/-- Insurance market with two risk types -/
structure InsuranceMarket where
  L : ℝ                     -- loss amount
  π_h : ℝ                  -- high-risk loss probability
  π_l : ℝ                  -- low-risk loss probability
  u_l : ℝ × ℝ → ℝ         -- low-type utility on (benefit, premium)
  u_h : ℝ × ℝ → ℝ         -- high-type utility on (benefit, premium)
  u_tilde_l : ℝ            -- max u_l over fair high-risk policies {(B,p) : p = π_h · B}

/-- A separating equilibrium: beliefs, acceptance, and optimality conditions -/
structure IsSeparatingEq (M : InsuranceMarket) (ψl ψh : ℝ × ℝ) : Prop where
  sep : ψl ≠ ψh
  beliefs : ∃ β : ℝ × ℝ → ℝ, β ψl = 1 ∧ ∀ q, q ≠ ψl → β q = 0
  accept_l : ψl.2 ≥ M.π_l * ψl.1
  accept_h : ψh.2 ≥ M.π_h * ψh.1
  ic_high : M.u_h ψh ≥ M.u_h ψl
  high_full : ψh = (M.L, M.π_h * M.L)
  low_opt : M.u_l ψl ≥ M.u_tilde_l

/-- The four characterizing conditions of Theorem 8.1 -/
structure FourConditions (M : InsuranceMarket) (ψl ψh : ℝ × ℝ) : Prop where
  cond1_sep : ψl ≠ ψh
  cond1_full : ψh = (M.L, M.π_h * M.L)
  cond2 : ψl.2 ≥ M.π_l * ψl.1
  cond3 : M.u_l ψl ≥ M.u_tilde_l
  cond4 : M.u_h ψh ≥ M.u_h ψl

/-- **Theorem 8.1**: Policies form a separating equilibrium iff conditions (1)–(4) hold. -/
theorem Theorem_8_1 (M : InsuranceMarket) (ψl ψh : ℝ × ℝ) :
    IsSeparatingEq M ψl ψh ↔ FourConditions M ψl ψh := by
  constructor
  · intro h
    exact ⟨h.sep, h.high_full, h.accept_l, h.low_opt, h.ic_high⟩
  · intro h
    exact {
      sep := h.cond1_sep
      beliefs := ⟨fun q => if q = ψl then 1 else 0,
        if_pos rfl, fun q hq => if_neg hq⟩
      accept_l := h.cond2
      accept_h := by simp [h.cond1_full]
      ic_high := h.cond4
      high_full := h.cond1_full
      low_opt := h.cond3
    }