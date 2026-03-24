import Mathlib
open Topology

-- Model lotteries/gambles and the indifference relation with mixing
-- G1: ≿ is a complete preorder (we only need that g ~ g, i.e., reflexivity of indifference)
-- G5: if g ~ g' and h ~ h', then α∘g + (1-α)∘h ~ α∘g' + (1-α)∘h'

theorem Claim_2_4_d
    {G : Type*}
    (sim : G → G → Prop)
    (mix : G → G → ℝ → G)
    (hsim_symm : ∀ g h, sim g h → sim h g)
    (hsim_refl : ∀ g, sim g g)
    -- G5: independence axiom for indifference
    (hG5 : ∀ g g' h h' : G, ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
      sim g g' → sim h h' → sim (mix g h α) (mix g' h' α))
    -- mix g g α = g (mixing a gamble with itself yields itself)
    (hmix_self : ∀ g : G, ∀ α : ℝ, sim (mix g g α) g)
    (hsim_trans : ∀ a b c, sim a b → sim b c → sim a c)
    (g h : G) (α : ℝ) (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (hgh : sim g h) :
    sim (mix g h α) g := by
  -- By G5 with g ~ g and h ~ g (since g ~ h implies h ~ g... wait, we need h ~ g)
  -- Actually: g ~ g (refl) and h ~ g (symm of hgh)
  -- So by G5: mix g h α ~ mix g g α
  -- And mix g g α ~ g by hmix_self
  -- Therefore mix g h α ~ g by transitivity
  have h1 : sim g g := hsim_refl g
  have h2 : sim h g := hsim_symm g h hgh
  have h3 : sim (mix g h α) (mix g g α) := hG5 g g h g α hα0 hα1 h1 h2
  have h4 : sim (mix g g α) g := hmix_self g α
  exact hsim_trans _ _ _ h3 h4