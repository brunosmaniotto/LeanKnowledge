import Mathlib

/-- Under Theorem 5.8 assumptions, x_bar is a Walrasian equilibrium allocation for prices p_bar
    under any redistribution of endowments along the price line through x_bar. -/
theorem walrasian_equilibrium_endowment_redistribution
    {I : Type*} [Fintype I]
    {Alloc Endow Price : Type*}
    (isWalrasianEquil : Price → (I → Endow) → (I → Alloc) → Prop)
    (value_alloc : Price → I → Alloc → ℝ)
    (value_endow : Price → I → Endow → ℝ)
    (equil_from_values : ∀ (p : Price) (e e' : I → Endow) (x : I → Alloc),
      (∀ i, value_endow p i (e i) = value_alloc p i (x i)) →
      (∀ i, value_endow p i (e' i) = value_alloc p i (x i)) →
      isWalrasianEquil p e x → isWalrasianEquil p e' x)
    (p_bar : Price) (e_bar : I → Endow) (x_bar : I → Alloc)
    (hequil : isWalrasianEquil p_bar e_bar x_bar)
    (hbalance : ∀ i, value_endow p_bar i (e_bar i) = value_alloc p_bar i (x_bar i))
    (e_star : I → Endow)
    (hline : ∀ i, value_endow p_bar i (e_star i) = value_alloc p_bar i (x_bar i)) :
    isWalrasianEquil p_bar e_star x_bar := by
  exact equil_from_values p_bar e_bar e_star x_bar hbalance hline hequil