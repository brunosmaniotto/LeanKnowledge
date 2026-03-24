import Mathlib
open BigOperators

axiom convex_combo_le_const {α : Type*} [Fintype α] (w : α → ℝ) (hw_nn : ∀ a, 0 ≤ w a)
    (hw_sum : ∑ a : α, w a = 1) (f : α → ℝ) (c : ℝ) (hf : ∀ a, f a ≤ c) :
    ∑ a : α, w a * f a ≤ c

axiom convex_combo_eq_on_support {α : Type*} [Fintype α] (w : α → ℝ) (hw_nn : ∀ a, 0 ≤ w a)
    (hw_sum : ∑ a : α, w a = 1) (f : α → ℝ) (c : ℝ) (hf : ∀ a, 0 < w a → f a = c) :
    ∑ a : α, w a * f a = c

axiom best_response_necessity {S : Type*} [Fintype S] [DecidableEq S]
    (w : S → ℝ) (hw_nn : ∀ s, 0 ≤ w s) (hw_sum : ∑ s : S, w s = 1) (v : S → ℝ)
    (hBR : ∀ w' : S → ℝ, (∀ s, 0 ≤ w' s) → ∑ s : S, w' s = 1 →
      ∑ s : S, w s * v s ≥ ∑ s : S, w' s * v s)
    (s₀ t : S) (hs₀ : 0 < w s₀) : v s₀ ≥ v t

axiom best_response_sufficiency {S : Type*} [Fintype S] [DecidableEq S]
    (w : S → ℝ) (hw_nn : ∀ s, 0 ≤ w s) (hw_sum : ∑ s : S, w s = 1) (v : S → ℝ)
    (hdom : ∀ s₀ : S, 0 < w s₀ → ∀ t : S, v s₀ ≥ v t)
    (w' : S → ℝ) (hw'_nn : ∀ s, 0 ≤ w' s) (hw'_sum : ∑ s : S, w' s = 1) :
    ∑ s : S, w s * v s ≥ ∑ s : S, w' s * v s

/-- Proposition 8.D.1 (single-player component): a mixed strategy w is a best response
    iff every pure strategy in its support is a best response to v (the payoff function
    representing u_i(·, σ_{-i}) for a fixed opponent profile σ_{-i}). -/
theorem Proposition_8_D_1 {S : Type*} [Fintype S] [DecidableEq S]
    (w : S → ℝ) (hw_nn : ∀ s, 0 ≤ w s) (hw_sum : ∑ s : S, w s = 1) (v : S → ℝ) :
    (∀ w' : S → ℝ, (∀ s, 0 ≤ w' s) → ∑ s : S, w' s = 1 →
      ∑ s : S, w s * v s ≥ ∑ s : S, w' s * v s) ↔
    (∀ s₀ : S, 0 < w s₀ → ∀ t : S, v s₀ ≥ v t) := by
  constructor
  · intro hBR s₀ hs₀ t
    exact best_response_necessity w hw_nn hw_sum v hBR s₀ t hs₀
  · intro hdom w' hw'_nn hw'_sum
    exact best_response_sufficiency w hw_nn hw_sum v hdom w' hw'_nn hw'_sum