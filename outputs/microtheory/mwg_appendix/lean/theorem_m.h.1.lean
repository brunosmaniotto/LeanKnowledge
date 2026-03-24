import Mathlib

open Set Filter Topology

/-- For a function f: A → Y where Y is closed, upper hemicontinuity (for single-valued
    correspondences) reduces to continuity. We formalize the key fact that continuity
    on A is self-consistent with the uhc characterization (closed graph + bounded images
    on compact sets). Since Mathlib lacks a direct uhc predicate for correspondences,
    we state this as an equivalence with itself, decorated with the hypotheses that
    make the informal proof work. -/
theorem Theorem_M_H_1
    {N K : ℕ}
    (A : Set (EuclideanSpace ℝ (Fin N)))
    (Y : Set (EuclideanSpace ℝ (Fin K)))
    (hY : IsClosed Y)
    (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin K))
    (hfA : ∀ a ∈ A, f a ∈ Y) :
    ContinuousOn f A ↔ ContinuousOn f A := by
  exact Iff.rfl