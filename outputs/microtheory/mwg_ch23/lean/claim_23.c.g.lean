import Mathlib
open Topology

noncomputable section

theorem clarke_is_second_price_auction
    {n : ℕ} (hn : 2 ≤ n)
    (v : Fin n → ℝ)
    (hv : Function.Injective v)
    (winner : Fin n)
    (hwinner : ∀ j, v j ≤ v winner)
    (second : ℝ)
    (runner_up : Fin n)
    (hru_ne : runner_up ≠ winner)
    (hru_val : v runner_up = second)
    (hru_max : ∀ k, k ≠ winner → v k ≤ v runner_up)
    : (∀ j, v j ≤ v winner) ∧
      (∀ i, (∀ j, j ≠ i → v j < v i) ↔ i = winner) ∧
      (∀ i, i = winner → ∀ k, k ≠ i → v k ≤ second) ∧
      (∃ j, j ≠ winner ∧ v j = second) := by
  refine ⟨hwinner, ?_, ?_, ⟨runner_up, hru_ne, hru_val⟩⟩
  · intro i
    constructor
    · intro hi
      by_contra hne
      have := hi winner (Ne.symm hne)
      linarith [hwinner i]
    · intro hi
      subst hi
      intro j hj
      exact lt_of_le_of_ne (hwinner j) (fun h => hj (hv h))
  · intro i hi
    subst hi
    intro k hk
    rw [← hru_val]
    exact hru_max k hk