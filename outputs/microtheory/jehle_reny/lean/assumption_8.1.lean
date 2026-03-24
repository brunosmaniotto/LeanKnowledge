import Mathlib

/-- Assumption 8.1: Monotone Likelihood Ratio Property.
    `π l e` is the probability of loss `l` under effort `e ∈ {0,1}`.
    MLRP: the ratio `π l 0 / π l 1` is strictly increasing in `l`. -/
structure MLRP where
  L : ℕ
  π : Fin (L + 1) → Fin 2 → ℝ
  π_pos : ∀ l e, 0 < π l e
  mlrp : StrictMono (fun l : Fin (L + 1) => π l 0 / π l 1)