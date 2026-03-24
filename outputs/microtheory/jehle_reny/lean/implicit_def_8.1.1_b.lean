import Mathlib

open Set

/-- An insurance market for adverse selection analysis.
    There are `m` consumers and many (competitive) insurance companies.
    Each consumer `i` has an independent accident probability `π i ∈ [0,1]`,
    common initial wealth `w`, common accident loss `L`, and a shared
    von Neumann–Morgenstern utility function `u` that is continuous,
    strictly increasing, and strictly concave. -/
structure InsuranceMarket (m : ℕ) where
  /-- Accident probability for consumer i -/
  π : Fin m → ℝ
  /-- Each accident probability lies in [0, 1] -/
  hπ_mem : ∀ i, π i ∈ Icc (0 : ℝ) 1
  /-- Common initial wealth -/
  w : ℝ
  /-- Loss in dollars if an accident occurs -/
  L : ℝ
  /-- von Neumann–Morgenstern utility of wealth function -/
  u : ℝ → ℝ
  /-- u is continuous -/
  hu_cont : Continuous u
  /-- u is strictly increasing -/
  hu_mono : StrictMono u
  /-- u is strictly concave -/
  hu_conc : StrictConcaveOn ℝ univ u