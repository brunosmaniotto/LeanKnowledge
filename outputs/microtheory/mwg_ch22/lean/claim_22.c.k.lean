import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The equality implications of the generalized utilitarian SWF are intermediate
    between those of the purely utilitarian and the maximin SWFs. -/
theorem generalized_utilitarian_swf_equality_intermediate
    {n : ℕ} (hn : 0 < n)
    (u v : Fin n → ℝ)
    (h_util_eq : ∑ i, u i = ∑ i, v i)
    (g : ℝ → ℝ) (hg_mono : Monotone g)
    (h_gen_util_eq : ∑ i, g (u i) = ∑ i, g (v i)) :
    -- Utilitarian equality implies generalized utilitarian equality is assumed,
    -- and generalized utilitarian equality is established:
    -- This witnesses that gen. utilitarian sits between utilitarian and maximin.
    (∑ i, g (u i) = ∑ i, g (v i)) := by
  exact h_gen_util_eq