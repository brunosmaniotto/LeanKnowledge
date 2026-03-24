import Mathlib

open Topology

theorem isClosed_iff_closure_eq {α : Type _} [TopologicalSpace α] {s : Set α} :
    IsClosed s ↔ closure s = s :=
  ⟨fun h => h.closure_eq, fun h => by rw [← h]; exact isClosed_closure⟩