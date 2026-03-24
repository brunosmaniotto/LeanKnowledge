import Mathlib
open Topology

variable {n : ℕ}

/-- Homothetic cost separability implies conditional input demand separability.
    If c(w,y) = h(y)·c(w,1), then by Shephard's lemma ∇_w c(w,y) = h(y)·∇_w c(w,1),
    i.e., x(w,y) = h(y)·x(w,1). -/
theorem Theorem_3_4_1b
    (c : (Fin n → ℝ) → ℝ → ℝ)
    (h : ℝ → ℝ)
    (hcost : ∀ w y, c w y = h y * c w 1)
    (hc_diff : Differentiable ℝ (fun w => c w 1))
    (w : Fin n → ℝ) (y : ℝ) :
    fderiv ℝ (fun w => c w y) w = h y • fderiv ℝ (fun w => c w 1) w := by
  have heq : (fun w => c w y) = fun w => h y • c w 1 := by
    ext w'; simp only [hcost w' y, smul_eq_mul]
  rw [heq]
  exact ((hc_diff w).hasFDerivAt.const_smul (h y)).fderiv