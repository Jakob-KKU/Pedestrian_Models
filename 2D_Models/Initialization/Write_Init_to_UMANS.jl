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
