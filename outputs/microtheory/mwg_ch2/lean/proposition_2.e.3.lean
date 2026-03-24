import Mathlib

open Finset BigOperators
open BigOperators

variable {L : ℕ}

theorem Proposition_2E3
    (x : (Fin L → ℝ) → ℝ → Fin L → ℝ)
    (p : Fin L → ℝ)
    (w₀ : ℝ)
    (hx_diff : ∀ l : Fin L, DifferentiableAt ℝ (fun w => x p w l) w₀)
    (walras : ∀ w, ∑ l : Fin L, p l * x p w l = w) :
    ∑ l : Fin L, p l * deriv (fun w => x p w l) w₀ = 1 := by
  have hd : ∀ l : Fin L, HasDerivAt (fun w => p l * x p w l)
      (p l * deriv (fun w => x p w l) w₀) w₀ :=
    fun l => (hx_diff l).hasDerivAt.const_mul (p l)
  have hsf := HasDerivAt.sum (fun (l : Fin L) (_ : l ∈ Finset.univ) => hd l)
  rw [show (∑ l : Fin L, fun w => p l * x p w l) = (fun w => ∑ l, p l * x p w l) from
    funext fun w => Finset.sum_apply w Finset.univ _] at hsf
  rw [show (fun w => ∑ l, p l * x p w l) = fun w => w from funext walras] at hsf
  exact hsf.unique (hasDerivAt_id w₀)