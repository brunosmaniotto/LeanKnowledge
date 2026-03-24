import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

variable {n : ℕ}

/-- Slutsky compensated wealth: when prices change from `p` to `p'`,
    wealth is adjusted to `w' = p' ⬝ x(p, w)` so the original
    bundle remains just affordable. -/
noncomputable def slutskyCompensatedWealth
    (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p p' : Fin n → ℝ)
    (w : ℝ) : ℝ :=
  ∑ i : Fin n, p' i * (x p w) i

/-- Slutsky wealth adjustment: `Δw = Δp ⬝ x(p, w)` where `Δp = p' - p`. -/
noncomputable def slutskyWealthAdjustment
    (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p p' : Fin n → ℝ)
    (w : ℝ) : ℝ :=
  ∑ i : Fin n, (p' i - p i) * (x p w) i

/-- A compensated price change bundles the new prices `p'` together with
    the Slutsky-compensated wealth `p' ⬝ x(p, w)`. -/
noncomputable def slutskyCompensatedPriceChange
    (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p p' : Fin n → ℝ)
    (w : ℝ) : (Fin n → ℝ) × ℝ :=
  (p', slutskyCompensatedWealth x p p' w)