import Mathlib

theorem exists_least_counterexample (m : ℤ) (P : ℤ → Prop) (h : ¬ ∀ n, n ≥ m → P n) :
    ∃ x, x ≥ m ∧ ¬ P x ∧ ∀ y, m ≤ y → y < x → P y := by
  -- Convert the negation of a universal to an existential
  push_neg at h
  rcases h with ⟨n, hn_ge, hn_not⟩
  -- Define the set of counterexamples
  let S : Set ℤ := {x | x ≥ m ∧ ¬ P x}
  -- Show S is nonempty (we have at least one counterexample n)
  have hne : S.Nonempty := ⟨n, hn_ge, hn_not⟩
  -- Show S is bounded below by m
  have hbdd : ∃ b, ∀ x ∈ S, b ≤ x := ⟨m, fun x hx => hx.1⟩
  -- Obtain the least element of S using the integer well-ordering principle
  rcases Int.exists_least_of_bdd hbdd hne with ⟨x, hx, hmin⟩
  rcases hx with ⟨hx_ge, hx_not⟩
  -- x is our least counterexample
  refine ⟨x, hx_ge, hx_not, fun y hy_ge hy_lt => ?_⟩
  -- For any y with m ≤ y < x, we must have P y
  by_cases hPy : P y
  · exact hPy
  · -- If ¬P y, then y would be in S and x ≤ y, contradicting y < x
    have h_mem : y ∈ S := ⟨hy_ge, hPy⟩
    have : x ≤ y := hmin y h_mem
    linarith