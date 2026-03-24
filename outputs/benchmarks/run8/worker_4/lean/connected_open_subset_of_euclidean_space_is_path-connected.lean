import Mathlib

open Set

theorem connected_open_subset_is_path_connected {n : ℕ} (U : Set (Fin n → ℝ))
    (hU_open : IsOpen U) (hU_conn : IsConnected U) : IsPathConnected U := by
  haveI : NormedAddCommGroup (Fin n → ℝ) := by infer_instance
  haveI : NormedSpace ℝ (Fin n → ℝ) := by infer_instance
  haveI : LocPathConnectedSpace (Fin n → ℝ) := by infer_instance
  exact (hU_open.isConnected_iff_isPathConnected).mp hU_conn