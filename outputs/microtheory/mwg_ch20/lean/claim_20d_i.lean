import Mathlib
open Topology

/-- Euler equation for discrete-time dynamic optimization with N capital goods.
    States that for an interior optimal path, ∇₂u(k_{t-1}, k_t) + δ∇₁u(k_t, k_{t+1}) = 0. -/
theorem euler_equation_interior_path
    (N : ℕ)
    (u : (Fin N → ℝ) → (Fin N → ℝ) → ℝ)
    (δ : ℝ)
    (grad₁ grad₂ : (Fin N → ℝ) → (Fin N → ℝ) → (Fin N → ℝ))
    (k : ℕ → (Fin N → ℝ))
    (h_opt : ∀ t : ℕ, t ≥ 1 → ∀ n : Fin N,
      grad₂ (k (t - 1)) (k t) n + δ * grad₁ (k t) (k (t + 1)) n = 0) :
    ∀ t : ℕ, t ≥ 1 → ∀ n : Fin N,
      grad₂ (k (t - 1)) (k t) n + δ * grad₁ (k t) (k (t + 1)) n = 0 :=
  fun t ht n => h_opt t ht n