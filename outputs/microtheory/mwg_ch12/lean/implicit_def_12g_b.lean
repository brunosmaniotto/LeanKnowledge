import Mathlib
open Topology

/-- Strategic complements and substitutes (Bulow, Geanakoplos, Klemperer, 1985).
    When firm 2's best response increases with firm 1's strategy, s₁ is a strategic
    complement of s₂. When it decreases, s₁ is a strategic substitute. -/
structure StrategicComplement (S₁ S₂ : Type*) [Preorder S₁] [Preorder S₂] where
  /-- Firm 2's best response function -/
  bestResponse₂ : S₁ → S₂
  /-- Best response is monotone: more aggressive s₁ leads to more aggressive s₂ -/
  response_monotone : Monotone bestResponse₂

/-- Strategic substitutes: firm 2 becomes less aggressive when firm 1 becomes more aggressive. -/
structure StrategicSubstitute (S₁ S₂ : Type*) [Preorder S₁] [Preorder S₂] where
  /-- Firm 2's best response function -/
  bestResponse₂ : S₁ → S₂
  /-- Best response is antitone: more aggressive s₁ leads to less aggressive s₂ -/
  response_antitone : Antitone bestResponse₂