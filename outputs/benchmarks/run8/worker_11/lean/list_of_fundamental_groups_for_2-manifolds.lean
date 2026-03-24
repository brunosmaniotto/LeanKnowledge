import Mathlib

open FundamentalGroupoid

noncomputable section

-- The circle S¹
def circle := TopCat.of (Metric.sphere (0 : ℂ) 1)

-- Base point for the circle