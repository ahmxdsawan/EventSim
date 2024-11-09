# Verbose Printing

Verbose printing allows you to print out event and state information while the simulation is running.
You typically use it when running the simulation only once, i.e. when using `runsim()` and not `repeat()`.

The verbose system is designed so that when it is not used, e.g. `runsim(mysim; verbose = false)` or simply `runsim(mysim)`, the verbose function calls are not even compiled, so they do not slow down the system at all (similar to using #debug in C)

To use verbose printing, you need to define various verbose functions that dispatch off of various predefined singletons

With these functions defined, when you run

    runsim(mysim; verbose = true)

the various verbose functions are run, printing to stdout the information requested as the simulation runs.

For example, during each iteration state information is printed out provided the following method is defined:

    function verbose(::☼State☼, sim::MyQSystem, state)
        @printf("%7d %7d %7s %7d", state.N, state.queue, string(state.isbusy), state.NW)
    end

Note: in the example, the state field `.isbusy` is a Bool, which is not a string. So it is  converted into a string to be able to use the printf code %s.

## Available Verbose Methods

    verbose(h::☼Header☼,     sim::MyQSystem)           =  @printf("%s", "print out the header")
    verbose(l::☼Line☼,       sim::MyQSystem, i)        =  nothing                     # default
    verbose(t::☼Time☼,       sim::MyQSystem, currTime) =  @printf("[%4d]", currTime)
    verbose(pre::☼PreEvent☼, sim::MyQSystem)           =  ☼preevent(sim, "before")
    verbose(e::☼Event☼,      sim::MyQSystem, e::D3)    =  ☼event(sim, "service", e)
    verbose(s::☼State☼,      sim::MyQSystem, state)    =  @printf("%7d %7d %7s %7d", state.N, state.queue, string(state.isbusy), state.NW)
    verbose(dv::☼Divider☼,   sim::MyQSystem)           =  println()                   # default
    verbose(f::☼Footer☼,     sim::MyQSystem)           =  @printf("%s", "print out the footer")

☼Header☼ and ☼Footer☼ is just printed once, at the beginning and the end of the run

All other verbose dispatch singletons are performed on every iteration

☼Line☼ is used to print line number, i.e. which iteration is currently being printed

☼Time☼ is used to print current system time from the scheduler (built into EventList), i.e. what is the current time of the event that is being printed.

☼Divider☼ is printed at the end of the iteration. It is used to separate the iterations from each other. The default is to use the end_line character (`\n`), however, if you want to print it on one line you could use the tab (`\t`), or comma (`, `), etc.  

All other verbose methods should be self explanatory.    

Note:  ☼ = \sun    when using tab completion UNICODE