import Mathlib
open Topology

theorem golden_rule_efficiency
    (F : ℝ → ℝ) (c_bar k_bar : ℝ)
    (hk_pos : 0 < k_bar)
    (hsteady : F k_bar = k_bar + c_bar)
    (hconcave : ∀ k : ℝ, k < k_bar → F k - c_bar < k)
    (k₀ : ℝ) (hk₀ : k₀ < k_bar) :
    let path : ℕ → ℝ := fun n => Nat.recOn n k₀ (fun _ k_prev => F k_prev - c_bar)
    ∀ n : ℕ, path (n + 1) < path n := by
  intro path
  have hbelow : ∀ n, path n < k_bar := by
    intro n
    induction n with
    | zero => exact hk₀
    | succ m ihm =>
      have hdec : path (m + 1) < path m := hconcave (path m) ihm
      linarith
  intro n
  exact hconcave (path n) (hbelow n)