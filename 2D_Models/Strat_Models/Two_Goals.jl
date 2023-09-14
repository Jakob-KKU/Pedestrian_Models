println("WATCH OUT WHEN AGENTS REACH THE SECOND GOAL, THEY ARE DELETED")
println("BUT IN THE OUTPUT THE AGENTS NOW DO NOT HAVE A CONSTANT ID!!!")


function Update_Desired_Headings!(menge::crowd, system_size)

    second_goal = (system_size[1]/2, system_size[2]-1.0)

    for (i, x) in enumerate(menge.agent)

        if d(x, x.goal) < .4

            if x.goal != second_goal

                x.goal = second_goal
                x.e_des = e_(x, x.goal, system_size).*(-1)

            else

                deleteat!(menge.agent, i)

            end

        else

            x.e_des = e_(x, x.goal, system_size).*(-1)

        end

    end

end
;
