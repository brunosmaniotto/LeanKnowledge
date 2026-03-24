import Mathlib

noncomputable section

structure FiniteGame where
  I : Type*
  [finI : Fintype I]
  [decI : DecidableEq I]
  S : I → Type*
  [finS : ∀ i, Fintype (S i)]
  [neS : ∀ i, Nonempty (S i)]
  u : I → ((j : I) → S j) → ℝ

attribute [instance] FiniteGame.finI FiniteGame.decI FiniteGame.finS FiniteGame.neS

def MixedStr (G : FiniteGame) (i : G.I) := G.S i → ℝ

axiom IsNE (G : FiniteGame) (m : ∀ i, MixedStr G i) : Prop
axiom IsWeaklyDom (G : FiniteGame) (i : G.I) (σ : MixedStr G i) : Prop
axiom IsTHPNE (G : FiniteGame) (m : ∀ i, MixedStr G i) : Prop

-- Proposition 8.F.1: Every finite game has a trembling-hand perfect NE
axiom thpne_exists (G : FiniteGame) : ∃ m : ∀ i, MixedStr G i, IsTHPNE G m

-- Every THPNE is a Nash equilibrium
axiom thpne_is_ne (G : FiniteGame) (m : ∀ i, MixedStr G i) :
    IsTHPNE G m → IsNE G m

-- Proposition 8.F.2: THPNE strategies are not weakly dominated
axiom thpne_not_weakly_dom (G : FiniteGame) (m : ∀ i, MixedStr G i) :
    IsTHPNE G m → ∀ i, ¬IsWeaklyDom G i (m i)