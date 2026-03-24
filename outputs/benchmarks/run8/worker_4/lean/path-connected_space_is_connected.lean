import Mathlib

variable {T : Type} [TopologicalSpace T]

theorem pathConnectedSpace_implies_connectedSpace (h : PathConnectedSpace T) : ConnectedSpace T := by
  haveI : PathConnectedSpace T := h
  exact inferInstance