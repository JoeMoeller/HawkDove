using StatsBase
using Plots

mutable struct Bird 
    health 
    strategy
end

function addhundredbirds(population)
    for i ∈ 1:50
        push!(population, Bird(100, "Hawk"))
        push!(population, Bird(100, "Dove"))
    end
end

function CountBird(p)
    numHawk = 0
    numDove = 0
    for bird ∈ p
        if bird.strategy == "Hawk"
            numHawk +=bird.health
        end
        if bird.strategy == "Dove"
            numDove +=bird.health
        end
    end
    return (numHawk, numDove)
end

function PrintBird(p)
    # print total health for both Hawks and Doves
    (numHawk, numDove) = CountBird(p)
    println("Hawks = $numHawk, Doves = $numDove")
end


# this function picks out two birds from the population, 
# and adjusts their health points depending on their relative strategies.
function fight(p::Vector{Bird})
    n = length(p)
    if n < 2
        println("Nobody to fight.")
    else
        fighter = sample(1:n, 2, replace = false)
        if p[fighter[1]].strategy == "Hawk"
            if p[fighter[2]].strategy == "Hawk"
                # big violent fight
                p[fighter[1]].health -=50
                p[fighter[2]].health -=50

            elseif p[fighter[2]].strategy == "Dove"
                p[fighter[1]].health +=20 # gets the food no problem
                # Dove loses/gains nothing
            else
                println("Someone has a rogue strategy.")
            end
        elseif p[fighter[1]].strategy == "Dove"
            if p[fighter[2]].strategy == "Hawk"
                # Dove loses/gains nothing
                p[fighter[2]].health +=20 # gets the food no problem
            elseif p[fighter[2]].strategy == "Dove"
                p[fighter[1]].health +=10 #share the food
                p[fighter[2]].health +=10 #share the food
            else
                println("Someone has a rogue strategy.")
            end
        else
            println("Someone has a rogue strategy.")
        end

        #birth/death checks
        for i ∈ 1:2
            if p[fighter[i]].health < 1 #death
                splice!(p, fighter[i])
            end
            if p[fighter[i]].health > 199 #birth
                push!(p, Bird[100, p[fighter[i]].strategy])
                p[fighter[i]].health -=100
            end
        end
    end
end


# testing
p::Vector{Bird} = []
addhundredbirds(p)


function BigFight(p::Vector{Bird}, n::Int)
    population = [] # initialize the time series for pairs of population counts
    for i ∈ 1:n #fill population array with the time series data
        fight(p)
        push!(population, CountBird(p))
    end
    # use array comprehension to extract the time series for each population
    hawks = [birds[1] for birds ∈ population]
    doves = [birds[2] for birds ∈ population]
    gr() # backend for plotting
    plot(1:n, hawks, label = "Hawks")
    plot!(1:n, doves, label = "Doves")
    # first one is plot to create the plot, 
    # second is plot! to mutate the first plot
end