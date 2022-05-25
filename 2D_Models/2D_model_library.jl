#initialization functions
include("./Initialization/Init_Struct.jl")
include("./Initialization/Init_System.jl")
include("./Initialization/Init_Geometry.jl")
include("./Initialization/Init_SimpleSituations.jl")

#general functions
include("./General_Functions/Vectors.jl")
include("./General_Functions/TTC.jl")
include("./General_Functions/TimeGap.jl")
include("./General_Functions/Sets.jl")
include("./General_Functions/Score.jl")
include("./General_Functions/TimeGap_Ant.jl")


#interfaces to other packages
include("./Interface_Packages/Voronoi_Cells.jl")


#general modeling functions
include("./FirstOrder_Model.jl")
include("./Neighbors.jl")
include("./Update_Functions.jl")

#plotting and analyzing
include("./Plotting_Analyzing/Observables.jl")
include("./Plotting_Analyzing/Plot_Functions.jl")
include("./Plotting_Analyzing/Velocity_Obstacles.jl")


#include model
function include_model(model)

    path = "/home/jakob/Dokumente/Git_Project/2D_Models/Models/"
    include(string(path, model, ".jl"))

end

function include_v_des(x)

    path = "/home/jakob/Dokumente/Git_Project/2D_Models/V_des/"
    include(string(path, x, ".jl"))

end

#include update
function include_update(scheme)

    path = "/home/jakob/Dokumente/Git_Project/2D_Models/Update_Schemes/"
    include(string(path, scheme, ".jl"))

end

#include order
function include_order(order)

    path = "/home/jakob/Dokumente/Git_Project/2D_Models/Order/"
    include(string(path, order, ".jl"))

end

#special scenario
function load_scenario(x)

    path = "/home/jakob/Dokumente/Git_Project/2D_Models/Scenarios/"
    include(string(path, x, ".jl"))

end


;
