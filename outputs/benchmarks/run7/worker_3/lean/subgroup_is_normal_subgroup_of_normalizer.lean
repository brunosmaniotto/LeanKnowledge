import Mathlib

theorem subgroup_normal_in_normalizer {G : Type*} [Group G] (H : Subgroup G) :
    (H.subgroupOf H.normalizer).Normal := 
  Subgroup.normal_in_normalizer