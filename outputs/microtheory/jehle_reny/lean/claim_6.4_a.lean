import Mathlib

/-- Under the Rawlsian maximin criterion, social state x is preferred to y
    iff min{u₁(x),...,uₙ(x)} > min{u₁(y),...,uₙ(y)} (equation 6.15). -/
theorem claim_6_4_a {α : Type*} {N : ℕ} [NeZero N]
    (u : Fin N → α → ℝ) (x y : α)
    (W : α → ℝ)
    (hW : ∀ z, W z = Finset.inf' Finset.univ Finset.univ_nonempty (fun i => u i z)) :
    W x > W y ↔
    Finset.inf' Finset.univ Finset.univ_nonempty (fun i => u i x) >
    Finset.inf' Finset.univ Finset.univ_nonempty (fun i => u i y) := by
  rw [hW x, hW y]