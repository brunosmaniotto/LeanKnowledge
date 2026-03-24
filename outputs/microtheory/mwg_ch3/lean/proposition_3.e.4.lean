import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

/-- Inner product of two vectors -/
noncomputable def inner_prod (a b : Fin n → ℝ) : ℝ :=
  ∑ i : Fin n, a i * b i

/-- The compensated law of demand: if h(p, u) minimizes expenditure at prices p
    (i.e., p · h(p,u) ≤ p · z for all feasible z), then for any two price vectors
    p' and p'', we have (p'' - p') · (h'' - h') ≤ 0. -/
theorem compensated_law_of_demand
    (p' p'' h' h'' : Fin n → ℝ)
    (opt1 : inner_prod p' h' ≤ inner_prod p' h'')
    (opt2 : inner_prod p'' h'' ≤ inner_prod p'' h') :
    inner_prod (p'' - p') (h'' - h') ≤ 0 := by
  unfold inner_prod at *
  simp only [Pi.sub_apply]
  have key : ∑ i : Fin n, (p'' i - p' i) * (h'' i - h' i) =
    (∑ i, p'' i * h'' i) - (∑ i, p'' i * h' i) -
    (∑ i, p' i * h'' i) + (∑ i, p' i * h' i) := by
    congr 1
    · have : ∑ i, (p'' i - p' i) * (h'' i - h' i) =
        ∑ i, (p'' i * h'' i - p'' i * h' i - p' i * h'' i + p' i * h' i) := by
        apply Finset.sum_congr rfl; intros; ring
      rw [this]
      simp [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  linarith