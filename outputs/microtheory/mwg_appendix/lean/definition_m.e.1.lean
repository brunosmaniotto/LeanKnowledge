import Mathlib

open Set Topology
open Topology

/-- We can locally solve the system f(x; q) = 0 at (x̄, q̄) for x as a function of q
    if there exist open neighborhoods A' ⊂ A of x̄ and B' ⊂ B of q̄, and uniquely
    determined implicit functions η from B' to A' such that f_n(η(q); q) = 0 for all
    q ∈ B' and η(q̄) = x̄. -/
def MWG.CanLocallySolve
    {N M : ℕ}
    (A : Set (Fin N → ℝ)) (B : Set (Fin M → ℝ))
    (f : Fin N → (Fin N → ℝ) → (Fin M → ℝ) → ℝ)
    (xbar : Fin N → ℝ) (qbar : Fin M → ℝ) : Prop :=
  ∃ (A' : Set (Fin N → ℝ)) (B' : Set (Fin M → ℝ)),
    IsOpen A' ∧ IsOpen B' ∧
    A' ⊆ A ∧ B' ⊆ B ∧
    xbar ∈ A' ∧ qbar ∈ B' ∧
    ∃ (eta : Fin N → (Fin M → ℝ) → ℝ),
      (∀ q ∈ B', (fun n => eta n q) ∈ A') ∧
      (∀ q ∈ B', ∀ n, f n (fun i => eta i q) q = 0) ∧
      (∀ n, eta n qbar = xbar n) ∧
      (∀ (eta' : Fin N → (Fin M → ℝ) → ℝ),
        (∀ q ∈ B', (fun n => eta' n q) ∈ A') →
        (∀ q ∈ B', ∀ n, f n (fun i => eta' i q) q = 0) →
        (∀ n, eta' n qbar = xbar n) →
        ∀ q ∈ B', ∀ n, eta' n q = eta n q)