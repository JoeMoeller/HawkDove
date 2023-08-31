using StatsBase
using Plots

mutable struct Hawk
    health::Int
end

mutable struct Dove
    health::Int
end

function AddHundredBirds(population)
    for i ∈ 1:50
        push!(population, Hawk(100))
        push!(population, Dove(100))
    end
end

function CountBird(p)
    numHawk = 0
    numDove = 0
    for bird ∈ p
        if typeof(bird) == Hawk
            numHawk += bird.health
        end
        if typeof(bird) == Dove
            numDove += bird.health
        end
    end
    return (numHawk, numDove)
end

function PrintBird(p)
    # print total health for both Hawks and Doves
    (numHawk, numDove) = CountBird(p)
    println("Hawks = ", numHawk/100, ", Doves = ", numDove/100)
end


function Duel(b1, b2)
    error("Quack!")
end

function Duel(b1::Hawk, b2::Hawk)
    b1.health -= 50
    b2.health -=50
end

function Duel(b1::Hawk, b2::Dove)
    b1.health +=20
end

function Duel(b1::Dove, b2::Hawk)
    b2.health +=20
end

function Duel(b1::Dove, b2::Dove)
    b1.health +=10
    b2.health +=10
end

# this function picks out two birds from the population, 
# and adjusts their health points depending on their relative strategies.
function fight(p)
    n = length(p)
    if n < 2
        println("Nobody to fight.")
    else
        fighter = sample(1:n, 2, replace = false)
        Duel(p[fighter[1]], p[fighter[2]])
        #birth/death checks
        for i ∈ 1:2
            if p[fighter[i]].health > 199 #birth
                push!(p, typeof(p[fighter[i]])(100))
                p[fighter[i]].health -=100
            end
        end
        if p[fighter[1]].health < 1 #death
            splice!(p, fighter[1])
            if fighter[2] > fighter[1]
                fighter[2] -=1
            end
        end
        if p[fighter[2]].health < 1 #death
            splice!(p, fighter[2])
        end
    end
end

# for testing
p = [i % 2 == 0 ? Hawk(100) : Dove(100) for i ∈ 1:100]


function BigFight(p, n::Int)
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
    # first one is "plot" to create the plot, 
    # second is "plot!" to mutate the first plot
end
