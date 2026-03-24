import Mathlib

open Subgroup

variable (G : Type*) [Group G] [Finite G]

def IsHall (N : Subgroup G) : Prop := Nat.Coprime (Nat.card N) (N.index)