import Mathlib

variable {G : Type} [Group G]

def centralizer (a : G) : Set G := {x | x * a = a * x}