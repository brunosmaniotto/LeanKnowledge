import Mathlib

theorem Claim_A1_3_l {α : Type*} [MetricSpace α] (D : Set α) :
    IsOpen (X := D) Set.univ := isOpen_univ