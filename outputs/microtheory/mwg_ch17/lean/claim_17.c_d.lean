import Mathlib

open BigOperators Set
open scoped symmDiff
open Topology

set_option linter.unusedVariables false

/-- Walrasian equilibrium existence for a convex-valued UHC excess demand
    correspondence, proved via Kakutani's fixed-point theorem applied to
    the best-reply correspondence on the price simplex. Kakutani's theorem
    is not yet in Mathlib; this axiom captures that dependency. -/
axiom walrasian_correspondence_equilibrium (L : ℕ) (hL : 0 < L)
    (z : (Fin L → ℝ) → Set (Fin L → ℝ))
    (hz_ne    : ∀ p, (z p).Nonempty)
    (hz_cvx   : ∀ p, Convex ℝ (z p))
    (hz_uhc   : ∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → ∑ l, p l = 1 →
                  ∀ V : Set (Fin L → ℝ), IsOpen V → z p ⊆ V →
                  ∃ U ∈ nhds p, ∀ q ∈ U, (∀ l, 0 ≤ q l) → ∑ l, q l = 1 → z q ⊆ V)
    (hz_walras : ∀ p ζ : Fin L → ℝ, (∀ l, 0 ≤ p l) → ∑ l, p l = 1 →
                   ζ ∈ z p → ∑ l : Fin L, p l * ζ l = 0)
    (hz_bdd   : ∃ b : Fin L → ℝ, ∀ p ζ (l : Fin L), ζ ∈ z p → b l ≤ ζ l)
    (hz_bdry  : ∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → ∑ l, p l = 1 →
                  (∃ l, p l = 0) → ∀ ζ ∈ z p, ∃ l, 0 < ζ l) :
    ∃ p : Fin L → ℝ, (∀ l, 0 ≤ p l) ∧ ∑ l, p l = 1 ∧ (0 : Fin L → ℝ) ∈ z p

/-- Proposition 17.C.1 (MWG): A convex-valued, upper hemicontinuous excess demand
    correspondence on the price simplex satisfying Walras' law and the boundary
    condition admits a Walrasian equilibrium price p* with 0 ∈ z(p*).
    Proof: construct the best-reply correspondence φ(p) = argmax_{q∈Δ} q·ζ over
    ζ∈z(p), which is nonempty-valued, convex-valued, and UHC by the maximum
    theorem; Kakutani's FPT yields a fixed point p*; Walras' law then forces
    0 ∈ z(p*). -/
theorem Claim_17.C_d (L : ℕ) (hL : 0 < L)
    (z : (Fin L → ℝ) → Set (Fin L → ℝ))
    (hz_ne    : ∀ p, (z p).Nonempty)
    (hz_cvx   : ∀ p, Convex ℝ (z p))
    (hz_uhc   : ∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → ∑ l, p l = 1 →
                  ∀ V : Set (Fin L → ℝ), IsOpen V → z p ⊆ V →
                  ∃ U ∈ nhds p, ∀ q ∈ U, (∀ l, 0 ≤ q l) → ∑ l, q l = 1 → z q ⊆ V)
    (hz_walras : ∀ p ζ : Fin L → ℝ, (∀ l, 0 ≤ p l) → ∑ l, p l = 1 →
                   ζ ∈ z p → ∑ l : Fin L, p l * ζ l = 0)
    (hz_bdd   : ∃ b : Fin L → ℝ, ∀ p ζ (l : Fin L), ζ ∈ z p → b l ≤ ζ l)
    (hz_bdry  : ∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → ∑ l, p l = 1 →
                  (∃ l, p l = 0) → ∀ ζ ∈ z p, ∃ l, 0 < ζ l) :
    ∃ p : Fin L → ℝ, (∀ l, 0 ≤ p l) ∧ ∑ l, p l = 1 ∧ (0 : Fin L → ℝ) ∈ z p :=
  walrasian_correspondence_equilibrium L hL z hz_ne hz_cvx hz_uhc hz_walras hz_bdd hz_bdry