import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Degenerate lottery: probability 1 on outcome i, 0 elsewhere -/
noncomputable def degenerate (n : ℕ) (i : Fin n) : Fin n → ℝ :=
  fun j => if j = i then 1 else 0

/-- Claim 2.4(g): If U has the expected utility form U(p) = Σ pᵢ · uᵢ,
    then U(p) = Σ pᵢ · U(δᵢ), where δᵢ is the degenerate lottery on outcome i.
    Hence U is completely determined by its values on pure outcomes. -/
theorem Claim_2_4_g {n : ℕ} (u : Fin n → ℝ) (p : Fin n → ℝ) :
    ∑ i : Fin n, p i * u i =
    ∑ i : Fin n, p i * (∑ j : Fin n, degenerate n i j * u j) := by
  congr 1
  ext i
  congr 1
  have : ∑ j : Fin n, degenerate n i j * u j = u i := by
    simp only [degenerate]
    rw [Finset.sum_eq_single i]
    · simp
    · intro j _ hji
      simp [hji]
    · intro h
      exact absurd (Finset.mem_univ i) h
  exact this.symm