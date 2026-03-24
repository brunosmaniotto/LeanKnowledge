import Mathlib

open BigOperators Finset

/-- A generalized utilitarian SWF has the form W(u) = Σᵢ gᵢ(uᵢ),
    where each gᵢ is increasing and concave. -/
structure GeneralizedUtilitarianSWF (ι : Type*) [Fintype ι] where
  /-- Individual transformation functions gᵢ -/
  g : ι → ℝ → ℝ
  /-- Each gᵢ is strictly monotone (increasing) -/
  g_strictMono : ∀ i, StrictMono (g i)
  /-- Each gᵢ is concave -/
  g_concave : ∀ i, ConcaveOn ℝ Set.univ (g i)

namespace GeneralizedUtilitarianSWF

variable {ι : Type*} [Fintype ι]

/-- The SWF: W(u) = Σᵢ gᵢ(uᵢ) -/
noncomputable def W (swf : GeneralizedUtilitarianSWF ι) (u : ι → ℝ) : ℝ :=
  ∑ i : ι, swf.g i (u i)

end GeneralizedUtilitarianSWF

/-- Symmetric generalized utilitarian SWF: all agents use the same g. -/
structure SymmetricGeneralizedUtilitarianSWF (ι : Type*) [Fintype ι] where
  /-- Common transformation function g -/
  g : ℝ → ℝ
  /-- g is strictly monotone (increasing) -/
  g_strictMono : StrictMono g
  /-- g is concave -/
  g_concave : ConcaveOn ℝ Set.univ g

namespace SymmetricGeneralizedUtilitarianSWF

variable {ι : Type*} [Fintype ι]

/-- The SWF: W(u) = Σᵢ g(uᵢ) -/
noncomputable def W (swf : SymmetricGeneralizedUtilitarianSWF ι) (u : ι → ℝ) : ℝ :=
  ∑ i : ι, swf.g (u i)

end SymmetricGeneralizedUtilitarianSWF