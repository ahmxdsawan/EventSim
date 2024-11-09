###########################################################################
#  Single Server System
###########################################################################
# -------------  [State]  -------------
#  queue::Int
#  busy::Bool
# -------------  [Stats]  -------------
#  N::Int
#  NW::Int
#  WQ::Time
#  WS::Time
#  T_idle::Time                             
#  Tmax::Time               (Const)
#  IAT::Time
###########################################################################

# -----------------------  [setup simulator]  --------------------------- #
include(pwd() * "/deps/build.jl")

TimeType(sim::SingleServerSystem)         = Float64
endtime(sim::SingleServerSystem)          = 100
servicetime(sim::SingleServerSystem)      = rand(3:12)
interarrivaltime(sim::SingleServerSystem) = rand(1:8)

sim = SingleServerSystem()

# -------------------------  [verbose run]  ----------------------------- #
runsim(sim, verbose = true)

# ----------------------  [run the simulator]  -------------------------- #
# results = repeat(sim, 30; busy = Skip, queue = Skip, Tmax = Const);
results = repeat(sim, 30);

# ------------------------  [perform stats]  ---------------------------- #
stat_WQ = results[:WQ]
mean(stat_WQ)
var(stat_WQ)

t_idle = results[:T_idle];
mean(t_idle)
confint(t_idle)

tmax = results[:Tmax]
mean(tmax)
tmax = results(Const)[:Tmax]
value(tmax)

results_WQ = results[:WQ]
mean(results_WQ)
var(results_WQ)

stat_WQ = results(NormalStats)[:WQ]
mean(stat_WQ)
var(stat_WQ)
