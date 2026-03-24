import Mathlib

theorem list_perm_prod_eq_of_comm {M : Type} [Monoid M] {as bs : List M}
    (h : bs.Perm as) (h_comm : ∀ x ∈ as, ∀ y ∈ as, Commute x y) : bs.prod = as.prod := by
  -- Helper lemma to convert global commutativity to pairwise commutativity for a list
  have list_pairwise_of_global_comm (l : List M) (h_comm_l : ∀ x ∈ l, ∀ y ∈ l, Commute x y) :
      l.Pairwise Commute := by
    induction l with
    | nil => exact List.Pairwise.nil
    | cons a l ih =>
      have H1 : ∀ y ∈ l, Commute a y := by
        intro y hy
        exact h_comm_l a (by simp) y (by simp [hy])
      have H2 : ∀ x ∈ l, ∀ y ∈ l, Commute x y := by
        intro x hx y hy
        exact h_comm_l x (by simp [hx]) y (by simp [hy])
      exact List.Pairwise.cons H1 (ih H2)
  -- Original list is pairwise commutative
  have h_pair_as : as.Pairwise Commute := list_pairwise_of_global_comm as h_comm
  -- The permuted list also satisfies global commutativity because it has the same elements
  have h_comm_bs : ∀ x ∈ bs, ∀ y ∈ bs, Commute x y := by
    intro x hx y hy
    have hx' : x ∈ as := h.mem_iff.1 hx
    have hy' : y ∈ as := h.mem_iff.1 hy
    exact h_comm x hx' y hy'
  -- Therefore the permuted list is pairwise commutative
  have h_pair_bs : bs.Pairwise Commute := list_pairwise_of_global_comm bs h_comm_bs
  -- Apply the permutation product lemma
  exact h.prod_eq' h_pair_bs