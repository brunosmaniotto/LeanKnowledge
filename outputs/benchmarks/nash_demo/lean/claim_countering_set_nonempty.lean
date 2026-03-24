import Mathlib
open Topology

/-- For any strategy profile, the countering set is nonempty:
    each player has a best response to the opponents' strategies. -/
theorem Claim_countering_set_nonempty
    {n : ℕ}
    {S : Fin n → Type*}
    [∀ i, Fintype (S i)]
    [∀ i, Nonempty (S i)]
    (u : (∀ i, S i) → Fin n → ℝ)
    (p : ∀ i, S i) :
    ∃ q : ∀ i, S i, ∀ i, ∀ s : S i,
      u (Function.update p i s) i ≤ u (Function.update p i (q i)) i := by
  choose q hq using fun i =>
    Finite.exists_max (fun s : S i => u (Function.update p i s) i)
  exact ⟨q, hq⟩