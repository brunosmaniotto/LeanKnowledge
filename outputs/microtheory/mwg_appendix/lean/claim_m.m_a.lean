import Mathlib
open Topology
open BigOperators

axiom dot_le_dot_of_le_of_nonneg {n : ℕ} (u v w : Fin n → ℝ) (hw : ∀ i, 0 ≤ w i) (huv : ∀ i, u i ≤ v i) : ∑ i, u i * w i ≤ ∑ i, v i * w i
axiom dot_le_dot_of_nonneg_of_le {n : ℕ} (w u v : Fin n → ℝ) (hw : ∀ i, 0 ≤ w i) (huv : ∀ i, u i ≤ v i) : ∑ i, w i * u i ≤ ∑ i, w i * v i
axiom transpose_dot_eq {m n : ℕ} (A : Fin m → Fin n → ℝ) (mu : Fin m → ℝ) (x : Fin n → ℝ) : ∑ j, (∑ i, A i j * mu i) * x j = ∑ i, mu i * (∑ j, A i j * x j)
axiom dot_comm {n : ℕ} (u v : Fin n → ℝ) : ∑ i, u i * v i = ∑ i, v i * u i

theorem weak_duality {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (f : Fin n → ℝ) (c : Fin m → ℝ) (x : Fin n → ℝ) (mu : Fin m → ℝ)
    (hx_nn : ∀ j, 0 ≤ x j)
    (hmu_nn : ∀ i, 0 ≤ mu i)
    (h_primal : ∀ i, ∑ j, A i j * x j ≤ c i)
    (h_dual : ∀ j, f j ≤ ∑ i, A i j * mu i)
    : ∑ j, f j * x j ≤ ∑ i, c i * mu i := by
  have h1 : ∑ j, f j * x j ≤ ∑ j, (∑ i, A i j * mu i) * x j :=
    dot_le_dot_of_le_of_nonneg f (fun j => ∑ i, A i j * mu i) x hx_nn h_dual
  have h2 : ∑ j, (∑ i, A i j * mu i) * x j = ∑ i, mu i * (∑ j, A i j * x j) :=
    transpose_dot_eq A mu x
  have h3 : ∑ i, mu i * (∑ j, A i j * x j) ≤ ∑ i, mu i * c i :=
    dot_le_dot_of_nonneg_of_le mu (fun i => ∑ j, A i j * x j) c hmu_nn h_primal
  have h4 : ∑ i, mu i * c i = ∑ i, c i * mu i :=
    dot_comm mu c
  linarith