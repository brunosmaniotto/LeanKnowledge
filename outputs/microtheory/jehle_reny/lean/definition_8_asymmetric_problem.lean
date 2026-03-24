import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Asymmetric information insurance problem (MWG 8.13–8.15). -/
structure AsymInfoInsurance where
  L : ℕ
  π : ℝ → Fin (L + 1) → ℝ
  u : ℝ → ℝ
  d : ℝ → ℝ
  w : ℝ
  u_bar : ℝ

namespace AsymInfoInsurance

/-- Consumer's expected utility: Σ_l π_l(e) u(w − p − l + B_l) − d(e) -/
noncomputable def EU (m : AsymInfoInsurance) (e p : ℝ) (B : Fin (m.L + 1) → ℝ) : ℝ :=
  (∑ l : Fin (m.L + 1), m.π e l * m.u (m.w - p - (l.val : ℝ) + B l)) - m.d e

/-- Insurer's expected profit: p − Σ_l π_l(e) B_l -/
noncomputable def profit (m : AsymInfoInsurance) (e p : ℝ) (B : Fin (m.L + 1) → ℝ) : ℝ :=
  p - ∑ l : Fin (m.L + 1), m.π e l * B l

/-- Contract (e, p, B) solves the asymmetric-info problem: maximizes profit subject to
    participation (8.14) and incentive compatibility (8.15), with effort in {0,1}. -/
def IsOptimal (m : AsymInfoInsurance) (e p : ℝ) (B : Fin (m.L + 1) → ℝ) : Prop :=
  e ∈ ({0, 1} : Set ℝ) ∧
  m.EU e p B ≥ m.u_bar ∧
  (∀ e', e' ∈ ({0, 1} : Set ℝ) → e' ≠ e → m.EU e p B ≥ m.EU e' p B) ∧
  (∀ e₂ p₂ : ℝ, ∀ B₂ : Fin (m.L + 1) → ℝ,
    e₂ ∈ ({0, 1} : Set ℝ) →
    m.EU e₂ p₂ B₂ ≥ m.u_bar →
    (∀ e', e' ∈ ({0, 1} : Set ℝ) → e' ≠ e₂ → m.EU e₂ p₂ B₂ ≥ m.EU e' p₂ B₂) →
    m.profit e₂ p₂ B₂ ≤ m.profit e p B)

end AsymInfoInsurance