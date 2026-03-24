import Mathlib

theorem continuous_of_restrict_on_separation {T T' : Type _} [TopologicalSpace T] [TopologicalSpace T']
    (A B : Set T) (hA_open : IsOpen A) (hB_open : IsOpen B) (h_cover : A ∪ B = Set.univ)
    (f : T → T') (hA_cont : ContinuousOn f A) (hB_cont : ContinuousOn f B) : Continuous f := by
  rw [continuous_iff_continuousAt]
  intro x
  have hx : x ∈ A ∪ B := by rw [h_cover]; exact Set.mem_univ x
  rcases hx with (hx | hx)
  · exact (hA_cont.continuousAt (hA_open.mem_nhds hx))
  · exact (hB_cont.continuousAt (hB_open.mem_nhds hx))