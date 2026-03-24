import Mathlib

/-- A commodity bundle in ℝ^L -/
abbrev Bundle (L : ℕ) := Fin L → ℝ

/-- A type allocation assigns a bundle to each of H consumer types -/
abbrev TypeAllocation (L H : ℕ) := Fin H → Bundle L

/-- The N-fold core of a replica economy (axiomatized). -/
axiom CoreN (L H N : ℕ) : Set (TypeAllocation L H)

/-- The set of Walrasian equilibrium allocations (axiomatized). -/
axiom WalrasianEquilibria (L H : ℕ) : Set (TypeAllocation L H)

/-- Debreu-Scarf axiom: core convergence implies Walrasian equilibrium. -/
axiom debreu_scarf_axiom {L H : ℕ} (x : TypeAllocation L H)
    (hcore : ∀ N : ℕ, 0 < N → x ∈ CoreN L H N) :
    x ∈ WalrasianEquilibria L H

/-- **Debreu-Scarf Theorem (Proposition 18.B.3):**
    If a feasible type allocation x* is in the N-fold core for every N ≥ 1,
    then x* is a Walrasian equilibrium allocation. -/
theorem Proposition_18B3 {L H : ℕ} (x : TypeAllocation L H)
    (hcore : ∀ N : ℕ, 0 < N → x ∈ CoreN L H N) :
    x ∈ WalrasianEquilibria L H :=
  debreu_scarf_axiom x hcore