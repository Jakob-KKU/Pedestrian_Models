function Open_Dir(dir, Path)

    cd(Path)

    if dir in readdir()

        cd(dir)

    else

        println("Created Directory /", dir, ".")
        mkdir(dir)
        cd(dir)

    end
end

function FileName(dir)

    my_time = Dates.format(Dates.now(), "_dd_u_yyyy_HHMMs")

    string(dir, my_time, ".txt")

end

function Header(p, p_desc, q, q_desc, op_model, tact_model, order, update, N, L)

    header1 = string("# From: ",Dates.now(), ", Email: j.cordes@fz-juelich.de \n")
    header2 = string("# ModelParameter: ", p, "\n")
    header3 = string("# ModelParameter: ", p_desc, "\n")
    header4 = string("# System Size: ", L, "\n")
    header5 = string("# No. of Agents: ", N,  "\n")
    header6 = string("# SimulationParameter: ", q, "\n")
    header7 = string("# SimulationParameter:", q_desc, "\n")
    header8 = string("# OP Model: ", op_model, ", Tact Model: ", tact_model, ", Order: ", order, ", Update: ", update, "\n")

    string(header1, header2, header3, header4, header5, header6, header7, header8)
end

Row_Names() = string("#id\tframe\tx\ty\n")
Row_Names_Vel() = string("#id\tframe\tx\ty\tv_x\tv_y\n")

Data_Row(id::Int, frame::Int, pos::NTuple{2, Float64}) = string(id, '\t', frame, '\t', pos[1], '\t', pos[2], '\n')
Data_Row(id::Int, frame::Int, pos::NTuple{2, Float64}, v::NTuple{2, Float64}) = string(id, '\t', frame, '\t', pos[1], '\t', pos[2],'\t', v[1], '\t', v[2], '\n')

function Write_Data!(f, positions)

    N_t, N = size(positions)
    write(f, Row_Names())

    for id in 1:N
        for frame in 1:N_t
            write(f, Data_Row(id, frame, positions[frame, id]))
        end
    end

end

function Save_Data!(Path, dir, Header, positions)

    file = FileName(dir)
    Open_Dir(dir, Path)

    touch(file)
    f = open(file, "w")

    #header = Header(p, p_desc, q, q_desc, op_model, tact_model, order, update, N, L)
    write(f, header)

    Write_Data!(f, positions)


    close(f)
end
