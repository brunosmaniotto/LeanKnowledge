import Mathlib

open Path

theorem joining_paths_makes_another_path {X : Type*} [TopologicalSpace X] {a b c : X}
    (f : Path a b) (g : Path b c) : Continuous (f.trans g) ∧ (f.trans g) 0 = a ∧ (f.trans g) 1 = c := by
  exact ⟨(f.trans g).continuous, (f.trans g).source, (f.trans g).target⟩