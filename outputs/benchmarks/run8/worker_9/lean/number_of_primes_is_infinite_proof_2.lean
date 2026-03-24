import Mathlib
open Set
open Finset

namespace IntTopology

-- Arithmetic progression S(a,b) = {a*n + b | n ∈ ℤ}
def S (a b : ℤ) : Set ℤ := {x | ∃ n : ℤ, x = a * n + b}

-- The topology on ℤ
instance : TopologicalSpace ℤ where
  IsOpen U := ∀ x ∈ U, ∃ a ≠ 0, S a x ⊆ U
  isOpen_univ := by
    intro x hx
    use 1, one_ne_zero
    intro y hy
    trivial
  isOpen_inter U V hU hV x hx := by
    rcases hx with ⟨hxU, hxV⟩
    rcases hU x hxU with ⟨a, ha, haU⟩
    rcases hV x hxV with ⟨b, hb, hbV⟩
    use a * b, mul_ne_zero ha hb
    intro y hy
    rcases hy with ⟨n, rfl⟩
    have h1 : a * b * n + x ∈ S a x := ⟨b * n, by ring⟩
    have h2 : a * b * n + x ∈ S b x := ⟨a * n, by ring⟩
    exact ⟨haU h1, hbV h2⟩
  isOpen_sUnion S hS x hx := by
    rcases hx with ⟨U, hU, hxU⟩
    rcases hS U hU x hxU with ⟨a, ha, h⟩
    use a, ha
    intro y hy
    exact ⟨U, hU, h hy⟩

-- S(a,b) is open for a ≠ 0