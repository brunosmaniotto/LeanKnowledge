import Mathlib

theorem Kernel_of_Group_Action_is_Normal_Subgroup
  {G X : Type*} [Group G] [MulAction G X] :
  (MonoidHom.ker (MulAction.toPermHom G X)).Normal :=
  MonoidHom.normal_ker (MulAction.toPermHom G X)