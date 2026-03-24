import Mathlib

variable {G : Type*} [Group G] (H : Subgroup G)

-- Define left and right cosets as sets
def leftCoset (x : G) : Set G := {g | ∃ h : H, g = x * h}