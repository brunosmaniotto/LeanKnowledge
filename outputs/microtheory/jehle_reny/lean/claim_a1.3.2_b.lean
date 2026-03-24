import Mathlib

open Finset BigOperators Topology
open Topology

theorem claim_A1_3_2_b (n : ℕ) (hn : 0 < n) :
    (stdSimplex ℝ (Fin n)).Nonempty ∧
    IsCompact (stdSimplex ℝ (Fin n)) ∧
    Convex ℝ (stdSimplex ℝ (Fin n)) := by
  have hn' : (n : ℝ) ≠ 0 := (Nat.cast_pos.mpr hn).ne'
  refine ⟨?_, isCompact_stdSimplex _, convex_stdSimplex ℝ (Fin n)⟩
  refine ⟨fun _ => 1 / (n : ℝ), fun _ => by positivity, ?_⟩
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  field_simp