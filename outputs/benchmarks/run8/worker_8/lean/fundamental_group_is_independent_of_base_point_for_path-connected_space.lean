import Mathlib

open FundamentalGroup

theorem Fundamental_Group_is_Independent_of_Base_Point_for_Path_Connected_Space
    (X : Type*) [TopologicalSpace X] [PathConnectedSpace X] (x y : X) :
    Nonempty (FundamentalGroup X x ≃* FundamentalGroup X y) :=
  ⟨fundamentalGroupMulEquivOfPathConnected x y⟩