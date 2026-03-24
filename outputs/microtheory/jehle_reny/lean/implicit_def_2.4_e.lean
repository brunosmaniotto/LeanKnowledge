import Mathlib

open BigOperators Finset
open Topology

/-- A simple gamble over `n` outcomes: assigns probability `prob i` to each
    outcome `a_i`, where each probability is non-negative and the total is 1. -/
structure SimpleGamble' (n : ℕ) where
  prob : Fin n → ℝ
  prob_nonneg : ∀ i, 0 ≤ prob i
  prob_sum : ∑ i, prob i = 1

/-- Recursive type of gambles over `n` fixed outcomes `{a_1, …, a_n}`.
    Base case: a simple gamble (probability vector over outcomes).
    Recursive case: a compound lottery mixing sub-gambles. -/
inductive Gamble' (n : ℕ) where
  | simple (p : Fin n → ℝ) (hp_nn : ∀ i, 0 ≤ p i) (hp_sum : ∑ i, p i = 1) : Gamble' n
  | compound {k : ℕ} (hk : 0 < k) (w : Fin k → ℝ) (sub : Fin k → Gamble' n)
      (hw_nn : ∀ i, 0 ≤ w i) (hw_sum : ∑ i, w i = 1) : Gamble' n

/-- Compute the effective (reduced) probability vector induced by any gamble `g`.
    For a simple gamble, this is the probability vector itself.
    For a compound gamble `(w₁ ∘ g₁, …, wₖ ∘ gₖ)`, the effective probability
    of outcome `aⱼ` is `∑ i, wᵢ · (effectiveProb gᵢ) j`, i.e., we recurse
    through all compound layers, multiplying and summing. -/
noncomputable def Gamble'.effectiveProb : Gamble' n → (Fin n → ℝ)
  | .simple p _ _ => p
  | .compound _ w sub _ _ => fun j => ∑ i, w i * (sub i).effectiveProb j

/-- **Implicit Definition 2.4(e)**: Every gamble `g ∈ G` induces a unique
    simple gamble `(p₁ ∘ a₁, …, pₙ ∘ aₙ) ∈ G_S`, where `pⱼ` is the
    effective probability of outcome `aⱼ` obtained by multiplying and summing
    probabilities through all compound layers of `g`. -/
noncomputable def Gamble'.inducedSimpleGamble (g : Gamble' n)
    (h_nn : ∀ j, 0 ≤ g.effectiveProb j)
    (h_sum : ∑ j, g.effectiveProb j = 1) : SimpleGamble' n where
  prob := g.effectiveProb
  prob_nonneg := h_nn
  prob_sum := h_sum