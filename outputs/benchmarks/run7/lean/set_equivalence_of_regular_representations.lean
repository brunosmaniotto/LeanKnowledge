import Mathlib

open Finset

variable {G : Type} [Group G] [DecidableEq G]

theorem left_regular_rep_card (a : G) (S : Finset G) : 
    (S.image (fun x => a * x)).card = S.card :=
  Finset.card_image_of_injective S (fun x y h => mul_left_cancel h)