import Mathlib

theorem Third_Sylow_Theorem (G : Type u) [Group G] [Fintype G] {p : ℕ} [Fact p.Prime] 
    (P Q : Sylow p G) : ∃ g : G, g • P = Q := by
  exact?