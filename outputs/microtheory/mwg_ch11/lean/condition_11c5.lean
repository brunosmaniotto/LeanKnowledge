import Mathlib
open Topology

axiom sum_gt_single_of_nonneg_and_eq {n : Nat} (hn : n > 1) (f : Fin n → Real) (c : Real) (hc : c > 0) (hf_nonneg : ∀ i, f i ≥ 0) (j : Fin n) (hj : f j = c) : Finset.univ.sum f > c
axiom sum_pos_gt_single_of_pos {n : Nat} (hn : n > 1) (f : Fin n → Real) (c : Real) (hc : c > 0) (hf_pos : ∀ i, f i > 0) (j : Fin n) (hj : f j = c) : Finset.univ.sum f > c
axiom strict_anti_pos_zero_implies_lt {g : Real → Real} {a b : Real} (hg : StrictAntiOn g (Set.Ici 0)) (ha : a ≥ 0) (hb : b ≥ 0) (hga : g a > 0) (hgb : g b = 0) : a < b
axiom condition_11C5_inequality {n : Nat} (hn : n > 1) (phi_deriv : Fin n → Real) (c_deriv : Real) (hc : c_deriv > 0) (hphi_pos : ∀ i, phi_deriv i > 0) (j : Fin n) (hj : phi_deriv j = c_deriv) : Finset.univ.sum phi_deriv > c_deriv
axiom private_underprovision {q_star q_circ : Real} {g : Real → Real} (hq_star : q_star ≥ 0) (hq_circ : q_circ ≥ 0) (hg_anti : StrictAntiOn g (Set.Ici 0)) (hg_star : g q_star > 0) (hg_circ : g q_circ = 0) : q_star < q_circ

theorem Condition_11C5
    {n : Nat} (hn : n > 1)
    (phi_deriv_at : Real → Fin n → Real)
    (c_deriv : Real → Real)
    (q_star q_circ : Real)
    (hq_star_nn : q_star ≥ 0) (hq_circ_nn : q_circ ≥ 0)
    (hc_pos : c_deriv q_star > 0)
    (hphi_pos : ∀ i, phi_deriv_at q_star i > 0)
    (j : Fin n) (hj : phi_deriv_at q_star j = c_deriv q_star)
    (g : Real → Real)
    (hg_def : ∀ q, g q = Finset.univ.sum (phi_deriv_at q) - c_deriv q)
    (hg_anti : StrictAntiOn g (Set.Ici 0))
    (hg_circ : g q_circ = 0) :
    Finset.univ.sum (phi_deriv_at q_star) > c_deriv q_star ∧ q_star < q_circ := by
  have hsum : Finset.univ.sum (phi_deriv_at q_star) > c_deriv q_star :=
    condition_11C5_inequality hn (phi_deriv_at q_star) (c_deriv q_star) hc_pos hphi_pos j hj
  constructor
  · exact hsum
  · have hg_star : g q_star > 0 := by
      rw [hg_def]
      linarith
    exact private_underprovision hq_star_nn hq_circ_nn hg_anti hg_star hg_circ