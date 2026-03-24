import Mathlib

open Real

theorem bernoulli_pgf_deriv (p s : ℝ) (k : ℕ) (hk : k ≥ 1) :
    iteratedDeriv k (fun s : ℝ => (1 - p) + p * s) s = if k = 1 then p else 0 := by
  set f : ℝ → ℝ := fun s => (1 - p) + p * s with hf_def
  have h_first_deriv : ∀ s, HasDerivAt f p s := by
    intro s
    dsimp [f]
    have h_const : HasDerivAt (fun _ : ℝ => (1 - p)) (0 : ℝ) s :=
      hasDerivAt_const (c := 1 - p) (x := s)
    have h_linear : HasDerivAt (fun s : ℝ => p * s) (p * 1) s :=
      HasDerivAt.const_mul p (hasDerivAt_id s)
    convert (h_const.add h_linear) using 1
    ring
  have h_deriv1 : ∀ s, deriv f s = p := fun s => (h_first_deriv s).deriv
  have h_deriv_fun : deriv f = fun _ => p := funext h_deriv1
  by_cases hk1 : k = 1
  · rw [hk1]
    simp [iteratedDeriv_one, h_deriv1 s]
  · have hk2 : 2 ≤ k := by omega
    have h_base : iteratedDeriv 2 f = fun _ => (0 : ℝ) := by
      ext s
      simp [iteratedDeriv_succ, iteratedDeriv_one, h_deriv_fun, deriv_const]
    have h_ind : ∀ k, 2 ≤ k → iteratedDeriv k f = fun _ => (0 : ℝ) := by
      intro k hk
      refine Nat.le_induction h_base (fun m hm h => ?_) k hk
      ext s
      simp [iteratedDeriv_succ, h, deriv_const]
    simp [h_ind k hk2, if_neg hk1]