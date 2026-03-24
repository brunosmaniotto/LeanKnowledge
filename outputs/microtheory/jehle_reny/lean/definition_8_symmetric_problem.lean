import Mathlib

open BigOperators Finset
open Topology

/-- The symmetric-information insurance problem (MWG Problem 8.7). -/
structure SymmetricInsuranceProblem (L : ℕ) where
  π : ℝ → Fin (L + 1) → ℝ
  u : ℝ → ℝ
  d : ℝ → ℝ
  w : ℝ
  u_bar : ℝ
  hπ_nonneg : ∀ e l, 0 ≤ π e l
  hπ_sum : ∀ e, ∑ l : Fin (L + 1), π e l = 1

noncomputable def SymmetricInsuranceProblem.expectedProfit
    {L : ℕ} (P : SymmetricInsuranceProblem L)
    (e p : ℝ) (B : Fin (L + 1) → ℝ) : ℝ :=
  p - ∑ l : Fin (L + 1), P.π e l * B l

noncomputable def SymmetricInsuranceProblem.consumerEU
    {L : ℕ} (P : SymmetricInsuranceProblem L)
    (e p : ℝ) (B : Fin (L + 1) → ℝ) : ℝ :=
  (∑ l : Fin (L + 1), P.π e l * P.u (P.w - p - ↑(l : ℕ) + B l)) - P.d e

def OwnerProblem14C8.IsFeasible
    {L : ℕ} (P : SymmetricInsuranceProblem L)
    (e p : ℝ) (B : Fin (L + 1) → ℝ) : Prop :=
  P.consumerEU e p B ≥ P.u_bar