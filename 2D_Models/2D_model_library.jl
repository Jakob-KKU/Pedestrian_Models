using Random
import Dates

#initialization functions
include("./Initialization/Init_Struct.jl")
include("./Initialization/Init_System.jl")
include("./Initialization/Init_Geometry.jl")
include("./Initialization/Init_SimpleSituations.jl")
include("./Initialization/Write_Init_to_UMANS.jl")

#general functions
include("./General_Functions/Vectors.jl")
include("./General_Functions/TTC.jl")
include("./General_Functions/TimeGap.jl")
include("./General_Functions/Sets.jl")
include("./General_Functions/Cost-Functions.jl")
include("./General_Functions/TimeGap_Ant.jl")
include("./General_Functions/DimensionlessNumbers.jl")


#interfaces to other packages
#include("./Interface_Packages/Voronoi_Cells.jl")

#general modeling functions
include("./Simulate_Model.jl")
include("./Neighbors.jl")
include("./Update_Functions.jl")

#plotting and analyzing
include("./Plotting_Analyzing/Observables.jl")
include("./Plotting_Analyzing/Plot_Functions.jl")

#output
include("./Save_Output.jl")

#include model
function include_op_model(model, path)

    include(string(path, "OP_Models/", model, ".jl"))

end

function include_tact_model(x, path)

    include(string(path, "Tact_Models/", x, ".jl"))

end

function include_strat_model(x, path)

    include(string(path, "Strat_Models/", x, ".jl"))

end

#include update
function include_update(scheme, path)

    include(string(path, "Update_Schemes/", scheme, ".jl"))

end

#include order
function include_order(order, path)

    include(string(path, "Order/", order, ".jl"))

end

#special scenario
function load_scenario(x, path)

    include(string(path, "Scenarios/", x, ".jl"))

end

#include optimization scheme
function include_optimization_scheme(x, path)

    include(string(path, "Optimization_Scheme/", x, ".jl"))

end


;
