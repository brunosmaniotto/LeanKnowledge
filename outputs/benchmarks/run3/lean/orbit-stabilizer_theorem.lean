import Mathlib

open MulAction
open Subgroup

theorem orbit_stabilizer_index_nat (G : Type u) [Group G] (X : Type v) [MulAction G X] (x : X) :
    Nat.card (orbit G x) = (stabilizer G x).index :=
  Nat.card_congr (orbitEquivQuotientStabilizer G x)