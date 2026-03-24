import Mathlib

noncomputable section

open Finset BigOperators
open Topology
open BigOperators

/-- V(p,w) = sup {u(x) | p·x ≤ w, x ≥ 0} -/
def IsIndirectUtilityOf {n : ℕ} (V : (Fin n → ℝ) → ℝ → ℝ) (u : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (p : Fin n → ℝ) (w : ℝ), (∀ i, 0 < p i) → 0 < w →
    V p w = sSup {v : ℝ | ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ w ∧ u x = v}

structure IndirectUtilityProperties {n : ℕ} (V : (Fin n → ℝ) → ℝ → ℝ) : Prop where
  homog : ∀ (t : ℝ) (p : Fin n → ℝ) (w : ℝ), 0 < t → V (t • p) (t * w) = V p w
  nondecr_w : ∀ (p : Fin n → ℝ), (∀ i, 0 < p i) → Monotone (V p)
  cont : Continuous (fun pw : (Fin n → ℝ) × ℝ => V pw.1 pw.2)

/-- Diewert (1974) recovery formula: given V with indirect utility properties,
    u(x) = inf_p V(p, p·x) generates V as an indirect utility function. -/
axiom diewert_recovery {n : ℕ} (V : (Fin n → ℝ) → ℝ → ℝ)
    (hV : IndirectUtilityProperties V) :
    IsIndirectUtilityOf V (fun x => sInf {v : ℝ | ∃ p : Fin n → ℝ, (∀ i, 0 < p i) ∧ v = V p (∑ i, p i * x i)})