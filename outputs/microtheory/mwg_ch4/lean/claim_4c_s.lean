import Mathlib

open Matrix Finset BigOperators
open Topology
open BigOperators

axiom SlutskyMatrix (n : ℕ) (i : ℕ) (p : Fin n → ℝ) (w : ℝ) : Matrix (Fin n) (Fin n) ℝ
axiom AggSlutskyMatrix (n : ℕ) (p : Fin n → ℝ) (w : ℝ) : Matrix (Fin n) (Fin n) ℝ
axiom wealthShare (I : ℕ) (i : Fin I) : ℝ

noncomputable def CMatrix (n I : ℕ) (p : Fin n → ℝ) (w : ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  (∑ i : Fin I, SlutskyMatrix n i p (wealthShare I i * w)) - AggSlutskyMatrix n p w

axiom homothetic_slutsky (n : ℕ) (i : ℕ) (p : Fin n → ℝ) (w α : ℝ) :
    SlutskyMatrix n i p (α * w) = α • SlutskyMatrix n i p w

axiom aggregate_slutsky_decomp (n I : ℕ) (p : Fin n → ℝ) (w : ℝ) :
    AggSlutskyMatrix n p w = ∑ i : Fin I, wealthShare I i • SlutskyMatrix n ↑i p w

theorem CMatrix_eq_zero (n I : ℕ) (p : Fin n → ℝ) (w : ℝ) :
    CMatrix n I p w = 0 := by
  unfold CMatrix
  rw [aggregate_slutsky_decomp n I p w]
  simp_rw [homothetic_slutsky n _ p w (wealthShare I _)]
  exact sub_self _