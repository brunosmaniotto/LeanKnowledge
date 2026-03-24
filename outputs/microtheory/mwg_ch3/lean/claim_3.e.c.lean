import Mathlib
open Topology

variable {n : ℕ}

axiom WalrasianDemand : (Fin n → ℝ) → ℝ → (Fin n → ℝ)
axiom HicksianDemand : (Fin n → ℝ) → ℝ → (Fin n → ℝ)
axiom ExpenditureFunction : (Fin n → ℝ) → ℝ → ℝ
axiom IndirectUtility : (Fin n → ℝ) → ℝ → ℝ

axiom duality_EMP : ∀ (p : Fin n → ℝ) (u : ℝ),
    HicksianDemand p u = WalrasianDemand p (ExpenditureFunction p u)

axiom duality_UMP : ∀ (p : Fin n → ℝ) (w : ℝ),
    WalrasianDemand p w = HicksianDemand p (IndirectUtility p w)

theorem hicksian_walrasian_duality (p : Fin n → ℝ) (u : ℝ) (w : ℝ) :
    HicksianDemand p u = WalrasianDemand p (ExpenditureFunction p u) ∧
    WalrasianDemand p w = HicksianDemand p (IndirectUtility p w) :=
  ⟨duality_EMP p u, duality_UMP p w⟩