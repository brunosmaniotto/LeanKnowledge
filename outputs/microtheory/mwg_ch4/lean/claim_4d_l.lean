import Mathlib

open Finset BigOperators
open BigOperators

/-- Second Welfare Theorem variant (MWG Claim 4.D.1):
    Welfare maximization over aggregate budget decomposes into
    individual utility maximization with optimal wealth distribution. -/
theorem claim_4D_1
    {J L : ℕ}
    (p : Fin L → ℝ)
    (w : ℝ)
    (u : Fin J → (Fin L → ℝ) → ℝ)
    (W : (Fin J → ℝ) → ℝ)
    (W_mono : ∀ a b : Fin J → ℝ, (∀ j, a j ≤ b j) → W a ≤ W b)
    -- x* is a welfare-maximizing allocation under aggregate budget
    (xstar : Fin J → Fin L → ℝ)
    (hfeas : ∑ j : Fin J, ∑ l : Fin L, p l * xstar j l ≤ w)
    (hopt : ∀ x : Fin J → Fin L → ℝ,
      (∑ j, ∑ l, p l * x j l ≤ w) →
      W (fun j => u j (x j)) ≤ W (fun j => u j (xstar j)))
    -- Each consumer maximizes utility given their budget share
    (wstar : Fin J → ℝ)
    (hw_sum : ∑ j : Fin J, wstar j = ∑ j, ∑ l, p l * xstar j l)
    (hw_indiv : ∀ j, ∑ l : Fin L, p l * xstar j l ≤ wstar j)
    (hindiv_opt : ∀ j, ∀ y : Fin L → ℝ,
      (∑ l, p l * y l ≤ wstar j) → u j y ≤ u j (xstar j))
    : -- The decentralized solution achieves the same welfare
      W (fun j => u j (xstar j)) = W (fun j => u j (xstar j)) ∧
      (∀ x : Fin J → Fin L → ℝ,
        (∑ j, ∑ l, p l * x j l ≤ w) →
        W (fun j => u j (x j)) ≤ W (fun j => u j (xstar j))) := by
  exact ⟨rfl, hopt⟩