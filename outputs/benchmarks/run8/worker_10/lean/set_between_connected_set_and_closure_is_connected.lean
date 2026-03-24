import Mathlib

theorem isConnected_of_subset_closure {T : Type u} [TopologicalSpace T] {H K : Set T}
    (hH_conn : IsConnected H) (hHK : H ⊆ K) (hK : K ⊆ closure H) : IsConnected K := by
  -- H is connected, so it's nonempty and preconnected
  have h_ne : H.Nonempty := hH_conn.nonempty
  have h_pre : IsPreconnected H := hH_conn.isPreconnected
  -- K is nonempty because it contains H
  have hK_ne : K.Nonempty := h_ne.mono hHK
  -- K is preconnected by the standard lemma
  have hK_pre : IsPreconnected K := h_pre.subset_closure hHK hK
  -- Combine to show K is connected
  exact ⟨hK_ne, hK_pre⟩