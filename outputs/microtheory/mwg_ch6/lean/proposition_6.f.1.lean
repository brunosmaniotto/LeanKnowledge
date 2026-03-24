import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure SEUPreferences (S : ℕ) where
  pref : (Fin S → ℝ) → (Fin S → ℝ) → Prop
  complete : ∀ x y, pref x y ∨ pref y x
  trans : ∀ x y z, pref x y → pref y z → pref x z

structure SEURepresentation (S : ℕ) (P : SEUPreferences S) where
  π : Fin S → ℝ
  u : ℝ → ℝ
  π_pos : ∀ s, 0 < π s
  π_sum : ∑ s : Fin S, π s = 1
  repr : ∀ x x' : Fin S → ℝ,
    P.pref x x' ↔ ∑ s : Fin S, π s * u (x s) ≥ ∑ s : Fin S, π s * u (x' s)

def ContinuityAxiom {S : ℕ} (P : SEUPreferences S) : Prop :=
  ∀ x y z : Fin S → ℝ, P.pref x y → P.pref y z →
    ∃ α : ℝ, 0 ≤ α ∧ α ≤ 1 ∧ P.pref (fun s => α * x s + (1 - α) * z s) y