function Write_BeginLine(input, tab=0)
    if tab == 0
        string("<", input, "> \n")
    elseif tab == 1
        string("\t<", input, "> \n")
    else
        string("\t\t<", input, "> \n")
    end
end

function Write_EndLine(input, tab=0)
    if tab == 0
        string("</", input, "> \n")
    elseif tab == 1
        string("\t</", input, "> \n")
    else
        string("\t\t</", input, "> \n")
    end
end

function Write_Line(input, tab=0)
    if tab == 0
        string("<", input, "/> \n")
    elseif tab == 1
        string("\t<", input, "/> \n")
    else
        string("\t\t<", input, "/> \n")
    end
end

function Write_Agent_Begin(a::agent)
    str = string("Agent rad=\"",a.l/2, "\" pref_speed=\"", a.v_des, "\" max_speed=\"", a.v_max, "\"")
    Write_BeginLine(str, 1)
end

function Write_Agent_Pos(a::agent)
    str = string("pos x=\"", a.pos[1], "\" y=\"",a.pos[2], "\"")
    Write_Line(str, 2)
end

function Write_Agent_Goal(a::agent)
    str = string("goal x=\"", a.goal[1], "\" y=\"",a.goal[2], "\"")
    Write_Line(str, 2)
end

function Write_PolicyID(id=0)
    str = string("Policy id=\"", id, "\"")
    Write_Line(str, 2)
end

function Write_Agent(a::agent, id = 0)

    str = string(Write_Agent_Begin(a), Write_Agent_Pos(a), Write_Agent_Goal(a), Write_PolicyID(id), Write_EndLine("Agent", 1))

end

function Write_Crowd(menge::crowd, id=0)

    str = Write_BeginLine("Agents")

    for a in menge.agent

        str = string(str, Write_Agent(a, id))

    end

    string(str, Write_EndLine("Agents"))
end

function Write_Agents_XML(menge::crowd, file, path)

    str = Write_Crowd(menge)

    open(string(path, file, ".xml"), "w") do test
        write(test, str)
    end
end

function Create_Scenario(δt, t_max, policy, agents, system_size)

    str_help = string("Simulation delta_time=\"", δt, "\" end_time=\"", t_max, "\"")

    str = Write_BeginLine(str_help)

    str_help = string("World type=\"Toric\" width=\"", system_size[1], "\" height=\"", system_size[2], "\"")
    #str_help = string("World type=\"Infinite\" width=\"", system_size[1], "\" height=\"", system_size[2], "\"")


    str = string(str, Write_Line(str_help, 1))

    str_help = string("Policies file=\"policies/", policy, ".xml\"")

    str = string(str, Write_Line(str_help, 1))

    str_help = string("Agents file=\"agents/", agents, ".xml\"")

    str = string(str, Write_Line(str_help, 1))

    string(str, Write_EndLine("Simulation"))

end

function Write_Scenario_XML(path, name, sim_p, system_size, policy, agents)

    str = Create_Scenario(sim_p[4], sim_p[2], policy, agents, system_size)

    open(string(path, name, ".xml"), "w") do file
        write(file, str)
    end
end
