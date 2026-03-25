import Mathlib
open Topology
open BigOperators

axiom sum_mul_eq_sum_sum {N M : ℕ} (mu : Fin M → ℝ) (gx : Fin M → Fin N → ℝ) (dx : Fin N → ℝ) : ∑ n : Fin N, (∑ m : Fin M, mu m * gx m n) * dx n = ∑ n : Fin N, ∑ m : Fin M, mu m * gx m n * dx n
axiom sum_sum_comm_mul {N M : ℕ} (f : Fin N → Fin M → ℝ) : ∑ n : Fin N, ∑ m : Fin M, f n m = ∑ m : Fin M, ∑ n : Fin N, f n m
axiom factor_sum {N M : ℕ} (mu : Fin M → ℝ) (gx : Fin M → Fin N → ℝ) (dx : Fin N → ℝ) : ∑ m : Fin M, ∑ n : Fin N, mu m * gx m n * dx n = ∑ m : Fin M, mu m * ∑ n : Fin N, gx m n * dx n
axiom envelope_core {N M S : ℕ} (grad_q_v grad_q_f : Fin S → ℝ) (grad_x_f : Fin N → ℝ) (grad_q_g : Fin M → Fin S → ℝ) (grad_x_g : Fin M → Fin N → ℝ) (Dx_q : Fin N → Fin S → ℝ) (mu : Fin M → ℝ) (chain_rule : ∀ s, grad_q_v s = grad_q_f s + ∑ n : Fin N, grad_x_f n * Dx_q n s) (foc : ∀ n, grad_x_f n = ∑ m : Fin M, mu m * grad_x_g m n) (constraint_diff : ∀ m s, ∑ n : Fin N, grad_x_g m n * Dx_q n s = -grad_q_g m s) : ∀ s, grad_q_v s = grad_q_f s - ∑ m : Fin M, mu m * grad_q_g m s

theorem envelope_theorem {N M S : ℕ}
  (grad_q_v grad_q_f : Fin S → ℝ)
  (grad_x_f : Fin N → ℝ)
  (grad_q_g : Fin M → Fin S → ℝ)
  (grad_x_g : Fin M → Fin N → ℝ)
  (Dx_q : Fin N → Fin S → ℝ)
  (mu : Fin M → ℝ)
  (chain_rule : ∀ s, grad_q_v s = grad_q_f s + ∑ n : Fin N, grad_x_f n * Dx_q n s)
  (foc : ∀ n, grad_x_f n = ∑ m : Fin M, mu m * grad_x_g m n)
  (constraint_diff : ∀ m s, ∑ n : Fin N, grad_x_g m n * Dx_q n s = -grad_q_g m s) :
  ∀ s, grad_q_v s = grad_q_f s - ∑ m : Fin M, mu m * grad_q_g m s :=
  envelope_core grad_q_v grad_q_f grad_x_f grad_q_g grad_x_g Dx_q mu chain_rule foc constraint_diff