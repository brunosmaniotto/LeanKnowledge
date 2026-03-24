import Mathlib

open Set
open Topology

/--
No utility function represents lexicographic preferences on ℝ²₊.
We define "represents" as: u(x) > u(y) ↔ x is lexicographically preferred to y.
The proof shows such a u would yield an injection ℝ → ℚ, which is impossible.
-/
theorem no_utility_for_lexicographic :
    ¬ ∃ u : ℝ × ℝ → ℝ,
      ∀ x y : ℝ × ℝ,
        (x.1 > y.1 ∨ (x.1 = y.1 ∧ x.2 > y.2)) ↔ u x > u y := by
  intro ⟨u, hu⟩
  -- For each x₁, u(x₁, 1) < u(x₁, 2) by lexicographic preference
  have hmono : ∀ x₁ : ℝ, u (x₁, 1) < u (x₁, 2) := by
    intro x₁
    exact ((hu (x₁, 2) (x₁, 1)).mp (Or.inr ⟨rfl, one_lt_two⟩))
  -- By density of ℚ, pick a rational in the open interval (u(x₁,1), u(x₁,2))
  have hq : ∀ x₁ : ℝ, ∃ q : ℚ, u (x₁, 1) < (q : ℝ) ∧ (q : ℝ) < u (x₁, 2) :=
    fun x₁ => exists_rat_btwn (hmono x₁)
  -- Choose such a rational for each x₁
  choose r hr using hq
  -- Show r is injective: if x₁ > y₁ then r(x₁) > r(y₁)
  have hinj : Function.Injective r := by
    intro a b hab
    by_contra hne
    cases ne_iff_lt_or_gt.mp hne with
    | inl hlt =>
      -- a < b, so (b,1) is lex-preferred to (a,2)
      have : u (a, 2) ≤ u (b, 1) := by
        by_contra h
        push_neg at h
        -- b > a gives u(b,1) > u(a,2) by lex preference
        have := ((hu (b, 1) (a, 2)).mp (Or.inl hlt)).le
        linarith
      have h1 := (hr a).2
      have h2 := (hr b).1
      have : (r a : ℝ) < r b := by
        calc (r a : ℝ) < u (a, 2) := h1
          _ ≤ u (b, 1) := this
          _ < r b := h2
      exact lt_irrefl _ (hab ▸ this)
    | inr hgt =>
      have : u (b, 2) ≤ u (a, 1) := by
        by_contra h
        push_neg at h
        have := ((hu (a, 1) (b, 2)).mp (Or.inl hgt)).le
        linarith
      have h1 := (hr b).2
      have h2 := (hr a).1
      have : (r b : ℝ) < r a := by
        calc (r b : ℝ) < u (b, 2) := h1
          _ ≤ u (a, 1) := this
          _ < r a := h2
      exact lt_irrefl _ (hab ▸ this)
  -- An injection ℝ → ℚ is impossible since ℝ is uncountable and ℚ is countable
  exact not_countable (hinj.countable)