import Mathlib

open Topology

variable {n : ℕ}

theorem Theorem_5_12
    (x : (Fin n → ℝ) → ℝ → Fin n → ℝ)
    (m : (Fin n → ℝ) → ℝ)
    (hx_cont : Continuous (fun (pw : (Fin n → ℝ) × ℝ) => x pw.1 pw.2))
    (hm_cont : Continuous m) :
    Continuous (fun p => x p (m p)) ∧ Continuous m := by
  refine ⟨?_, hm_cont⟩
  have h_pair : Continuous (fun p => (p, m p)) :=
    continuous_id.prodMk hm_cont
  exact hx_cont.comp h_pair