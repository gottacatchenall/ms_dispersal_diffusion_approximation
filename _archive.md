# The Archive

A collection of words from times I've tried and failed to write this paper.


## when can we approximate dispersal (github version, Nov 2020 - Jan 2021)


### Introduction

Human activity is rapidly altering our planet, leaving Earth's habitats
fragmented and patchy. This change has had profoundly altered Earth's
ecosystems, their functioning, and the services they provide to humans, and
understanding the consequences of land-use and climate change on ecological
processes remains a fundamental goal of ecological research. It us well
understood that landscape structure influences ecosystem processes [@cite] and
that promoting landscape connectivity can mitigate the negative effects of
habitat loss on ecosystem functioning [@resascoMetaanalysisDecadeTesting2019].
As a result understanding how habitat structure effects the movement and
dispersal of organisms, and how this scales up to explain the abundance and
distribution of species across space, is a primary aim of landscape ecology.
Models in landscape ecology---analytic, computational, and statistical--- have
long used diffusion to approximate model how organisms move or disperse between
habitat patches. What does it mean that model uses diffusion? The way in which
organisms move from one habitat patch to another, via active or passive
dispersal, is inherently stochastic. Diffusion approximates this stochastic
process by assuming the that stochastic process of movement of organisms between
two locations is equal to its expected value at every time point---ignoring any
temporal variation in dispersal. However, here we show that in some cases this
assumption creates artificially synchronized dynamics across space.

Why is it important we understand when dispersal is a valid approx of dispersal?
In order to design landscapes that mitigate biodiversity loss and its effects
[@albertApplyingNetworkTheory2017], we need models to understand how landscape
structure affects ecological processes. Understanding when dispersal is
well-approximated by diffusion, and when it isn't, is important because
diffusion models are much less computationally expensive.

We do this by using a simulation model with two parts: 1) a spatial graph model
of both stochastic dispersal and diffusion, and 2) a Ricker model of local
population dynamics. We then show that there are two regimes: one under which
diffusion creates highly synchronized dynamics where stochastic dispersal
doesn't, and one under which diffusion and stochastic dispersal produce similar
distributions of synchrony. We show that the boundaries between these regimes is
caused by both the modularity of the dispersal network and demographic
parameters.



### A Model of Metapopulation Dynamics of Spatial Graphs

Here, we present a model of metapopulation dynamics on spatial graphs. We use
this model to generate trajectories of metapopulation abundances using both
diffusion and stochastic dispersal, and then measure the synchrony of population
dynamics between populations. By comparing the synchrony created by stochastic
dispersal and diffusion models, we show there are distinct regimes in which the
primary source of variation in population abundances over time is driven
primarily by stochasticity in dispersal versus demography.

#### Spatial Graph Model of Landscape Connectivity

Spatial graphs have long been used to model a system of habitat patches
[dale_graphs_2010, minor_graph-theory_2008, urban_landscape_2001]. Here, we
present a model of a landscape, represented as a set of locations $L$ in a
spatial graph $G$, where the edges represent dispersal between populations. In
order to define how the edges of this network describe dispersal, we choose to
model landscape connectivity as a combination of two different factors: the
probability than any individual migrates during its lifetime, $m$, and the
conditional distribution over spatial nodes of where an individual goes ($j \in
L$), given both that it migrates $m$ and where it started ($i \in L$), which we
call the dispersal potential and denote

$$\Phi_{ij} =  P(L_i \to L_j | m)$$

The dispersal potential can be modeled several ways. In empirical systems, it is
often estimated with resistance surfaces, which provide relative weights of the
difficulty of movement between pairs of cells on a raster grid
\cite{spear_use_2010}. Here, however, we model the dispersal potential using
isolation-by-distance (IBD), which assumes the relative probability of dispersal
$L_i \to L_j$ is inversely proportional to the distance between them, $d_{ij}$,
and the strength of this isolation-by-distance relationship, $\alpha$. For the
functional form of this IBD relationship, called the dispersal kernel
\cite{grilli_metapopulation_2015, hanski_practical_1994}, we consider an
exponential with decay-strength $\alpha$ and a cutoff value $\epsilon$,

$$f(d_{ij}, \alpha, \epsilon) =  \begin{cases} e^{-\alpha d_{ij}}
\quad\quad\quad &\text{if}\quad e^{-\alpha d_{ij}} > \epsilon \ \ \text{and } i
\neq j \\   0 &\text{else} \end{cases}$$

Then, to construct a dispersal potential $\Phi_{ij}$ with a kernel $f(d_{ij},
\alpha)$,  we normalize:

$$\Phi_{ij} = \frac{f(d_{ij}, \alpha, \epsilon)}{\sum_k f(d_{ik},\alpha,
\epsilon)}$$

Note that the sum of each row of $\Phi$, forms a probability distribution, i.e.
$\sum_j \Phi_{ij} = 1 \ \ \forall i$, meaning the probability that an individual
leaves its original population given that it migrates is 1. In some cases, for a
given location $i$, the dispersal kernel $f(d_{ij}, \alpha, \epsilon)$ could be
$0$ for all $j$, in which case $\Phi_{ii}$ is set to $1$ to enforce this
condition. In all other cases, $\Phi_{ii}=0$. Also note that if $\alpha=0$, the
dispersal potential is a uniform distribution over other locations. In Figure
\ref{fig:mp}, we can see the same set of points plotted spatial graphs plotted
representing the same set of populations across differing values of
isolation-by-distance strength, $\alpha$.

![example metapops and dynamics trajectories](./figures/1_metapops.png)

#### Dynamics

##### Local Dynamics

We model local population dynamics using a Ricker Model. At each timestep, the abundance $N_i$ at location $i$ is drawn from

$$N_i(t+1) \sim \text{Poisson}\bigg(N_i(t) \lambda R e^{- \chi N_i(t)}\bigg)$$

where $\chi$ represents the strength of mortality of surviving until adulthood,
$R$ is the probability that an adult reproduces ($0.9$ for all results presented
here), and where $\lambda$ is the mean number of offspring for each individual
that reproduces---yielding three total parameters: $\theta = \{\lambda, R, \chi
\}$.  We consider the simplest variation on the model, which only includes
demographic stochasticity, however it is straightforward to extend this to other
forms of stochasticity \cite{melbourne_extinction_2008}.

#### Dispersal

##### Stochastic Dispersal

To model stochastic dispersal, for each location $i$, the number of migrants
leaving that location is drawn $m_{i} \sim \text{Binomial}(N_i, m)$ and for
every migrating individual $1, \dots, m_i$ we randomly draw where that
individual goes from the distribution $\Phi^{(i)}$.

##### Diffusion Dispersal

To model dispersal using diffusion, we incorporate the local Ricker Model into a
reaction-diffusion model. If the probability that an individual migrates before
reproducing is $m$, then we can define a diffusion matrix $D$ as

$$D_{ij} = \begin{cases} \Phi_{ij}m \quad\quad\quad &\ i \neq j \\ 1-m  & i=j \end{cases}$$

where $D_{ij}$ is now the expected value of the unit biomass that is born in $i$
that reproduces in $j$. The dispersal dynamics of the diffusion model are
described by the mapping

$$N_i(t+1) = \sum_j D_{ji} N_j(t)$$

which can be combined into the local Ricker model from above as
reaction-diffusion model by computing diffusion before each round of local
dynamics.

$$N_i(t+1) \sim \text{Poisson}\bigg( \lambda R e^{-\chi \big(\sum_j D_{ji}
N_j(t)\big)} \cdot \sum_j D_{ji} N_j(t) \bigg)$$


#### Measuring Synchrony

In ecology and other fields, the crosscorrelation function, \(CC\), has long
been used as a measure of the synchrony between two time-series
\cite{liebold_spatial_2004}. Here, with a metapopulation, we consider the mean
crosscorrelation across all pairs of populations, which we call the
Pairwise-Crosscorrelation ($\text{PCC}$) and compute as

$$\text{PCC}=\frac{1}{N_p(N_p-1)}\sum_{i > j} CC(N_i,N_j)$$

where $N_i$ is the time-series of abundances at population $i$.

#### Model Lifecycle

In Figure \ref{fig:lifecycle}, we see the lifecycle of the model for a given set
of parameter values, $\theta = \{R, \lambda, \chi, N_p, m, \alpha, \epsilon \}$.
For each set of parameters $\theta$, we run a simulation loop where a random
metapopulation of size $N_p$ is drawn via a Poisson Process in the unit square
$[0,1]^2$ and has a dispersal potential constructed according to $\{\alpha,
\epsilon \}$. Then, the dynamics of the metapopulation are simulated for $300$
timesteps, and the pairwise-crosscorrelation PCC is computed. This loop repeats
for $N_r$ replicates for each set of parameter values $\theta$---for everything
presented here $N_r=100$ unless otherwise mentioned. This forms an output
distribution of PCC values conditional on parameters, $\text{Pr}(\text{PCC} | \
\theta)$, which we use to compare between diffusion and stochastic dispersal
models to determine the values of $\theta$ for which diffusion is a valid
approximation of dispersal.

![conceptual](./figures/2_conceptual.png)

### Results

#### Synchrony across a migration gradient

We begin by considering the difference between the level of synchrony ($PCC$)
created by diffusion and stochastic dispersal models over a continuum of the
probability of migration $m$. In Figure {fig:mig_grad_lambda_facet}, we see the
simulated distribution of $PCC$ for models of both diffusion and stochastic
dispersal across the gradient of the probability of migration, $m = [0, 0.01,
0.02, \dots 0.99, 1]$, with different rows and columns corresponding to values
of $\alpha$ (connectivity) and $\lambda$ (base reproduction rate), respectively.

![The first figure](./figures/3_migration_grad_lambda_and_alpha.png)

At low $\lambda$, the diffusion model produces increasingly synchronized
population dynamics as migration increases; however, the stochastic dispersal
model produces effectively no synchrony regardless of migration rate. Yet, as
$\lambda$ increases, we see two phenomena: 1) the distribution of $\text{PCC}$
for both diffusion and stochastic model begin to move closer to one another, and
2) the shift from non-synchronized to synchronized dynamics becomes more
"critical", meaning it rapidly jumps to near $\text{PCC}=1.0$ as $m$ increases.

As we increase $\lambda$, the gap between the diffusion and stochastic PCC
distributions shrinks.  As we increase $\alpha$ to create more modular habitat
networks, we see two phenomena depending on the value of $\lambda$. At low
$\lambda$, the diffusion model produces lower synchrony and the stochastic
dispersal model continues to produce asynchronous dynamics. However, as
$\lambda$ increases, we see the difference in PCC between diffusion and
stochastic dispersal models shrink, as before, but the amount of variance in
this estimate increases and we increase the modularity of the habitat network
($\alpha$). In this case, the spatial configuration of habitat patches, and how
the dispersal structure of a randomly generated habitat network changes with
$\alpha$, is driving greater variation in the amount of synchrony observed at a
given set of parameter values.  

Now, we move to considering the relationship across gradients of both $\lambda$
and $m$ to determine where in parameter space this gap between diffusion and
stochastic dispersal emerges (Figure #{fig:single_lattice}).

![single lattice](./figures/4_single_lattice.png)

We see that there are two regimes here: one in which diffusion and stochastic
dispersal produce similarly synchronous dynamics, and one where they do not. The
validity of approximating dispersal with diffusion is highly dependent on the
structure of the habitat network and the demographic and dispersal parameters of
the species in question. To see what regions of parameter space where this
approximation holds, and to investigate the nature of the transition between
these two regimes, we now simulate dynamics over gradients of both $\lambda$ and
$m$.

So what is it that causes this gap between diffusion and stochastic dispersal
models in some cases, but not others? Here we identify two causes: the size of
each subpopulation, and the modularity of the habitat network.

The first cause is that the mean size of each subpopulation (here controlled by
$\lambda$) exhibits two phases (Figure Sampling Dist). As $\lambda$ increaes,
the size of each subpopulation increases. As a result, the number of migration
moving from any given population increaeses, even with fixed $m$. At the some
point, the size of this migrant distribution moves from a state where it is too
small to approximate the true dispersal probability distribution from a
population, $\Phi^{(i)}$, to a size large enough that it's sampling distribution
well approximates $\Phi^{(i)}$.

![sampling distribution](./figures/6_abundance_vs_pcc_diff_across_numpops.png)

The second cause is the modularity of the habitat network. As we increase the
IBD strength of a species $\alpha$, and the dispersal structure of the habitat
network, we see that diffusion model perform closer to the stochastic dispersal
model. A similar lattice of $\lambda$ and $m$ against modularity (represented as
$\alpha$) is shown is figure {ref}. ![lattice across
alpha](./figures/5_lattice_against_alpha.png)

One hypothesis is that diffusion doesn't work in habitat networks with low
modularity is because dispersal causes _even-mixing_ between populations. To
test this, we construct a matrix where $\alpha=0$ and $m = 1-(\frac{1}{N_p})$
The eigenvalues of the diffusion matrix include $0$.

![even mixing with annotatoin](./figures/7_evenmixing_annotated.png)

### Discussion

Here, we've shown that modeling the dispersal and movement of biological
entities across space with diffusion is appropriate in some cases, but not
others.

Spatial synchronization of population dynamics is widely observed in real
systems [@rantaPopulationVariabilitySpace1998]. It is broadly understood that
spatial synchrony is, in large part, driven by covariance in environmental
conditions across space [@bjornstadSpatialPopulationDynamics1999]---<blanks> Law
of geography---closer things are more likely to be similar than further things.
However, dispersal between populations can contribute to synchrony. In some
cases, dispersal-induced synchrony can increase the stability of the system
[@abbottDispersalinducedParadoxSynchrony2011].

Here, we treat each populations demographic stochasticity as independent to
isolate the effect of migration on creating synchrony across populations.

What now?
- Test if diffusion and stochastic dispersal produce same behavior for
a problem.
- Why do we care? Diffusion is much faster to simulate.
- Scale and what a location represents. We argue dispersal potential is a way to
describe landscape structure at any scale.
- Although at scales, the values of $m$ here seem high for many systems. however,
if locations represent different microclimates, this can be reasonable
- Spatial graph models as tool for
modeling ecological processes across space and as generative models.   
- Emergent properties and the role of stochasticity



## when can we approximate dispersal (overleaf version, June 2020 - Oct 2020)

### abstract

In ecology, spatial models have long approximated the dispersal of biological entities using diffusion models \cite{hastings_1978, okubo_diffusion_2001}.
We show that approximating dispersal with diffusion only works under some sets of demographic conditions.
We define a model of metapopulation dynamics on spatial graphs.
We simulate metapopulation dynamics, where local dynamics occur according to variations on
the Ricker model \cite{melbourne_hastings_2008}, and dispersal occurs either stochastic dispersal and diffusion.
We show that the dynamics produced by this model under stochastic dispersal differ from those produced by diffusion under certain parameterizations of the model.
We do this by measuring the synchrony of the dynamics across populations. We show that under some parameterizations, diffusion and stochastic dispersal models produce similarly synchronous dynamics across populations.
We identify two regimes--one where the variability in the abundances is primarily driven by
the stochasticity of dispersal, and another where the variability in abundance over time is primarily driven by the forces contributing to stochasticity \textit{within} each population.
We show that as the spatial metric becomes more modular, the diffusion approximation approaches stochastic dispersal.

### introduction


Humans impact nearly the entirety of planet earth \cite{watson_protect_2018}.
Climate change is exposing all ecosystems to rapidly shifting temperatures \cite{pereira_scenarios_2010}, and land-use change is causing terrestrial habitats to become smaller and patchier \cite{haddad_habitat_2015}. As a result, understanding and predicting the impacts of landscape change on Earth's ecosystems remains a central goal of modern ecological research \cite{fletcher_spatial_2019, fischer_landscape_2007}---both to impede ongoing loss of biodiversity, and to plan sustainable development to mitigate the effects of climate change \cite{albert_applying_2017,baguette_individual_2013}.
It has widely been shown that the spatial structure of habitat influences ecological processes \cite{haddad_experimental_2017, ricketts_matrix_2001, gilbert_corridors_1998, taylor_connectivity_1993}, and that increased \textit{landscape connectivity} can mitigate the negative effect of habitat loss on biodiversity.
\cite{resasco_meta-analysis_2019,
thompson_loss_2017, chisholm_metacommunity_2011}.

In order to design landscapes that mitigate biodiversity loss and its effects \cite{}, we need models to understand how landscape connectivity affects the dynamics of ecological processes. In ecology and other fields, spatial processes have long been modeled with \textit{diffusion} \cite{cantrell_spatial_2004, okubo_diffusion_2001, hastings_global_1978}.
Diffusion is often used to model the movement and dispersal of organisms between habitat patches. However, dispersal is inherently a stochastic process, which diffusion can only approximate. We show that in the context of metapopulation dynamics, diffusion models can generate highly synchronized dynamics across space in cases where stochastic dispersal does not.

Spatial synchronization of population dynamics is widely observed in real systems \cite{bjornstad_spatial_1999, ranta_population_1998}. It is broadly understood that spatial synchrony is, in large part, driven by covariance in environmental conditions \cite{bjornstad_spatial_1999}.
Here, we simulate each populations local dynamics as statistically independent to isolate the effect of migration on creating synchrony across populations.
It is understood that dispersal between populations can contribute to synchrony, and in some cases, increase the stability of the system \cite{abbott_dispersal-induced_2011}.

We use the synchrony of population dynamics as a measure of \textit{functional} connectivity \cite{}, meaning that in the context of metapopulation dynamics, movement between populations is the process driving connectivity: abundances shifting due to migration.

We show that both the modularity of the habitat network (represented by a spatial graph) and the demographic parameters of local population dynamics effect the validity of approximating dispersal with diffusion. We also show that total synchrony is a product of the even-mixing of local demographic stochasticity via dispersal. We do this by presenting a spatial graph model of dispersal, and then simulating metapopulation dynamics by combining a Ricker model of local population dynamics with either diffusion or stochastic dispersal.
We implement the software to used run these simulations as a Julia package `MetapopulationDynamics.jl`.

### discussion
- Test if diffusion and stochastic dispersal produce same behavior for a problem.
- Why do we care? Diffusion is much faster to simulate.
- one way to view this is diffusion ignores temporal variation in
- Scale and what a location represents. We argue dispersal potential is a way to describe landscape structure at any scale.
- Although at scales, the values of $m$ here seem high for many systems. however, if locations represent different microclimates, this can be reasonable
- Spatial graph models as tool for modeling ecological processes across space and as generative models.
- Emergent properties and the role of stochasticity
- Levins on models and abstraction



## thesis version (april 2020)

### Intro

Ecosystems are quintessential complex systems. Ecological processes are
inherently the product of interactions across all scales of biological
organization, from the interactions between electrons that drive
biochemical processes, to interactions between individual cells that
constitute multicellular life, to the interactions between separate
organisms in population ecology, to interactions between species in
community ecology, to interactions between biogeographical patterns and
biosphere level forces like climate (Levin 1992). This process of
\emph{emergence}, by which parts come together to form a whole with
properties that don't exist among the individual parts, has been studied
across a wide variety of disciplines (Manrubia et al. 2004), and is a
ubiquitous phenomenon in complex systems.

One potential cause of emergent behavior in complex systems is
\emph{synchrony} among individual parts. When many independent parts
come together to act as a whole, their dynamics become
\emph{synchronized}. This behavior is ubiquitous in biological systems
across all scale of organization. From collections of cells acting
together: the heart beating in rhythm (Womelsdorf et al. 2007), neurons
firing in unison (Strogatz 2003)---to behavior among organisms: the
flash of fireflies (Otte 1980) or the migration of birds (Spottiswoode
2004)---to interactions between organisms: synchrony between abundances
of predators and prey, and of phenology (Asch and Visser 2007, Burkle
and Alarcón 2011). Synchrony, by definition, involves different entities
changing over time in the same way. Within ecology, there has long been
a focus on spatial synchrony, that is---how does spatial distribution of
ecological entities affect whether they change together or separately?
(Jarillo et al. 2020, Kendall et al. 2000, Hanski and Woiwod 1993). This
is, in large part, due to the applied importance of understanding the
effect of habitat loss on natural populations. Many theoretical studies
have shown the two primary factors that develop spatial synchrony across
space are dispersal and environmental covariance (Ripa 2000, Abbott
2007). Within this theory, one maxim that has developed is \emph{Moran's
rule}, which states that spatial synchrony is proportional to the
covariance in the environmental conditions across space (Ranta et al.
1995, Bjørnstad et al. 1999).

A major goal of conservation has been developing corridors to promote
landscape connectivity. Most measures of landscape connectivity
represent \emph{structural} connectivity, meaning quantifying the
structure of the landscape, rather than \emph{functional} connectivity,
which measures the connectivity of a given process (Kool et al. 2013,
Calabrese and Fagan 2004). Here, in order to better understand
functional connectivity, we use a simulation model to measure how
synchrony across space changes as a function of landscape structure. We
do this by developing a model of metapopulation dynamics on spatial
graphs, which have long been used to model landscape connectivity
(Martensen et al. 2017, Albert et al. 2017, Urban and Keitt 2001), and
analyze how synchrony changes across space using the language of
critical transitions.

Further, we show that increasing population synchrony reduces the
variance in the generation-to-generation change in abundance, which is
central in reducing the probability of metapopulation extinction (Lande
1993, Lande et al. 1998). This relationship suggests that promoting
functional landscape connectivity can help mediate the probability of
extinction for species facing significant habitat loss. This result in
counterintuitive, as the prevailing consensus on population synchrony is
that it increases the probability of global extinction (Bjørnstad et al.
1999). However, we show that increasing connectivity in a landscape
reduces the variance in local abundances, which increases the mean time
until extinction (Lande et al. 2003). We then conclude by suggesting the
continued use of simulation models, such as those presented here, to aid
in corridor placement decision making.

### What are phase transitions


When does a system change from one state to a different state? Due to
the rapid changes induced on the planet by human activity, there has
been recent focus on answering this question in ecology, especially the
potential for changes in spatial structure to drive transitions between
alternative stable states. Much of this theory has been aimed at the
practical problem of being able to predicting the onset of transitions
from time-series data (Scheffer et al. 2012, Scheffer et al. 2009). The
bulk of the quantitative theory used to understand transitions between
states is derived from statistical mechanics, where it was originally
used to study phase-transitions in matter. In order to study phase
transitions between regimes, we must first be clear on what these
regimes are. As this theory was originally used to describe physical
states of matter, the original regimes were solid, liquid, gas. However,
as our understanding of condensed-matter has changed, so has the
demarcation of what constitutes different states. In reality, the way in
which particles come together to constitute matter is far more variable
than these three categories. In such cases the 'state' of a collection
of particles cannot be represented by a single categorical label, and so
the theory of phase transitions as been adapted to model
\emph{continuous} phase transitions, where there is no clear demarcation
point between different states (Sethna 2006). This is useful for us in
ecology, where the line between alternative ecosystem states is even
fuzzier.

We can formalize our understanding of phase transitions using the
language of statistical mechanics. We call the \emph{order parameter}
some measure of the system's state in space and time. The \emph{control
parameter}, then, is what causes the change in order parameter. When
dealing with dynamics that are inherently stochastic, one tool often
used in statistical mechanics is correlation functions which measure how
well the order parameter is correlated in both space and time at a
particular value of the control parameter (Sethna 2006). For example, if
we consider the population of a species inhabiting a landscape, where
along the gradient of landscape connectivity, our control parameter,
does that system go from consisting of one large, single, population, to
many small, independent populations? We measure this qualitative shift
from one system to many using \emph{synchrony}, the correlation in the
dynamics of abundance across space.


### The model

Here we present a spatial graph model of landscape connectivity based on
metapopulation theory (Hanski 1994, Grilli et al. 2015) . We model
connectivity as a function of a few empirically estimable parameters,
and then describe a diffusion model of metapopulation dynamics on these
spatial graphs. We then simulate dynamics across parameters
representative of landscape connectivity to determine where transitions
in the synchrony of population dynamics across space occur.

#### Modeling Landscape Connectivity with a Spatial Graph


Spatial graphs have long been used to model a system of habitat patches
(Dale and Fortin 2010, Minor and Urban 2008, Urban and Keitt 2001). In
figure \ref{concept}, we see a conceptual example of how these graphs
are constructed from land cover data.


Here we model a system of populations, represented as a vector of
vertices, \(V\), in a spatial graph \(G=(V,E)\), with edges, \(E\),
representing dispersal between populations. When considering the process
of metapopulation dynamics, we choose to model landscape connectivity as
a combination of two different factors: the probability than any
individual migrates during its lifetime, \(p_m\), and the conditional
distribution over spatial nodes of where an individual goes, given that
it migrates, \(P(V_j|V_i)\), which we call the dispersal potential.

We can model the dispersal potential using a few methods. In empirical
systems, this can be estimated with resistance surfaces, which provide
relative weights of the difficulty of migration between points on a
raster of land-cover type (Spear et al. 2010). Theoretically, we model
the dispersal potential using isolation-by-distance (IBD). The relative
probability of dispersal between \(V_i\) to \(V_j\) is inversely
proportional to the distance between them, \(d_{ij}\), and the strength
of the isolation-by-distance relationship, \(\alpha\). We call the
functional form of this relationship, \(f(d_{ij}, \alpha)\), the
dispersal kernel. Here we consider two different types (partially after
Grilli et al (2015)), the
exponential, \(f(d_{ij}, \alpha)=e^{-\alpha d_{ij}}\), and
Gaussian, \(f(d_{ij}, \alpha)=e^{-\alpha^2 d_{ij}^2}\), kernels. These
functional forms have long been considered as models of dispersal
kernels in both theory and empirical work (Hanski 1994, Grilli et al.
2015).

To convert this to a probability distribution \(P(V_j|V_i)\), we
normalize:


\[P(V_j|V_i)=\frac{f(d_{ij}, \alpha)}{\sum_k f(d_{ik},\alpha)}\]

Note that if \(\alpha=0\), then the value of both exponential and
Gaussian kernels is the same for all pairs of populations, and therefore
the dispersal potential is a uniform distribution. In figure \ref{mp},
we can see spatial graphs plotted representing the same set of
populations across differing values.

#### local dynamics


We model population dynamics within each local population \(V_i\) using
the stochastic logistic model. The dynamics of the number of individuals
in population \(V_i\) are described by the stochastic differential
equation (SDE)

\[dN_i=\lambda_i N_i \big(1 - \frac{N_i}{K_i}\big)dt+\sigma_pK_idW\]

Here, \(N_i\) is the abundance at population \(i\), \(\lambda_i\) is the
limiting growth rate in that population as density decreases, and
\(K_i\) is the carrying capacity of \(V_i\). \(\sigma_p\) represents
that standard deviation in abundance due to local stochasticity as a
proportion of \(K_i\). Here \(dW\) represents a differential value of
Brownian motion, as used in Itô-type stochastic differential equations,
and \(\sigma_p\) represents an amalgamation of all factors contributing
to local stochasticity in population dynamics. It should be noted that
the relative contribution of different factors to local stochasticity
can drive significant variation in dynamics (Melbourne and Hastings
2008). For the sake of reducing parameter space, here we consider all
populations as having the same \(\lambda_i\) and \(K_i\), however,
future work could include exploring the source-sink dynamics in this
system by varying intrinsic growth rates and carrying capacities across
populations.

We use an SDE representation because they have been used to study phase
transitions in stochastic systems before (Brock and Carpenter 2012,
Kuehn 2011), and they have many nice properties. SDEs have been used to
study extinction dynamics before, as it is relatively straightforward to
compute the mean time until extinction (MTE) using the Kolmogorov
Backward Equation (Lande et al. 2003).


#### Diffusion on Spatial Graphs

When we model a landscape with a spatial graph, we have to decide how
different nodes affect one another. The processes that connect
landscapes are inherently stochastic. The probability that an individual
migrates within its lifetime, \(p_m\), and where it goes, \(P(V_j|V_i)\)
, are both stochastic processes. Under some conditions, we can
effectively model stochastic dynamics across space using diffusion
models. In essence, a diffusion model assumes that at each timestep the
system will change according to the expected value of stochastic
dispersal. Diffusion models have seen widespread use in ecology and
other fields (Ovaskainen et al. 2008, Holmes et al. 1994, Ōkubo and
Levin 2011).

Given our dispersal potential \(P(V_j|V_i)\), we can define the
diffusion matrix \(\Phi\) as

\[\Phi_{ij} = \begin{cases} 1 - p_m \quad\quad &\text{if}\ i = j \\ P(V_j|V_i)p_m & \text{if}\ i \neq j\end{cases}\]

where \(\Phi_{ij}\) represents the probability that any individual born
in \(V_i\) reproduces in \(V_j\).

Now we move to considering the dynamics of the abundance of the
population at \(V_i\), denoted \(N_i\). We can now represent the
dynamics due to diffusion of this system as

\[\dot{N_i}=(1-p_m)N_i+ \sum_j p_mP(V_j|V_i)N_j\]

In matrix notation, we can represent this diffusion model as

\[\frac{d\vec{N}}{dt}=\Phi^T\vec{N}\]

We can then combine this with local dynamics as a reaction-diffusion
model,

\[\frac{d\vec{N}}{dt} = g(\Phi^T \vec{N})\]

where \(g(x)\) is a function that represents the hypothesized mechanism
of how the ecological measurement evolves locally. In principle, \(g(x)\) can represent any ecological process of
interest---for example if the state space of \(x\) is allelic
frequencies, \(g(x)\) could describe genetic drift, or if \(x\)
represents community compositions across space, \(g(x)\) could describe
competition between species as a function of environmental conditions,
coevolutionary states across space, etc. Here, we consider \(g(x)\) to
be the stochastic logistic model (see previous section). Combining this
with the diffusion model yields the vector SDE

$$
 d\boldsymbol{N} = ({I} \boldsymbol{\lambda})(\Phi^T \boldsymbol{N})({I}(\boldsymbol{k}-\Phi^T\boldsymbol{N})\boldsymbol{k}^{-1}) dt + \sigma_p \boldsymbol{k} \ d\boldsymbol{W}
$$


which will be the primary object of study in this paper. Here,
\(\boldsymbol{N}\) is a vector of abundances, \(\boldsymbol{k}\) is a
vector of carrying capacities, \(\boldsymbol{k}^{-1}\) is a vector of
inverses of carrying capacities, i.e.~\(k^{-1}_i = \frac{1}{k_i}\),
\(\boldsymbol{\lambda}\) is a vector of the limiting growth rate in each
population as density goes to \(0\), \(I\) is the identity matrix,
\(\Phi\) is the diffusion matrix described above, and
\(d\boldsymbol{W}\) is a vector of independent Brownian motion
differentials.


#### Measuring Synchrony

As described above, measures of correlation in space and time are often
used in the study of phase transitions. When the order parameter gains
or loses correlation in space and time is used as an indicator of when a
system changes qualitative phases. Within the context of ecology, the
crosscorrelation function, \(CC\), has long been used as a measure of
synchronous dynamics (Liebhold et al. 2004). Here, with a subdivided
population, we consider the mean crosscorrelation compared across all
populations, $${PCC}=\frac{1}{n_p^2}\sum_{i,j} CC(V_i,V_j)$$ As an
example, in \ref{async_and_sync}, panel (a) show an example of low PCC,
and panel (b) shows an example of high PCC.

#### Simulating a Phase Transition across a Migration Gradient


Now we consider how synchrony changes as a function of \(p_m\). Each run
consists of the following parameters,
\(\theta = \{N_p, \lambda, \sigma_p, \vec{K},p_m, \alpha \}\). For each
unique set of parameters, we run \(50\) replicates across all values of
\(p_m = \{0.01,0.02,\dots,1.0 \}\). For each replicate, we independently
draw the location of \(N_p\) populations uniformly in \([0,1]^2\). We
draw the intial value of abundance for all populations from a uniform
distribution, \(N_i \sim U(0, K_i)\). We then integrate equation
\ref{diffusion_model} forward \(500\) timesteps using the
Euler--Maruyama method with \(\Delta t=0.1\). After integrating forward,
we compute the crosscorrelation coefficient, \(CC\) for each pair of
populations \(i \neq j\). Then, we compute the mean pairwise
crosscorrelation for that replicate, \(PCC\), and start the next
replicate.

### Phase Transitions in Synchrony across a Migration Gradient


Here, we introduce synchrony transition diagrams. When does the
equilibrium state of our order parameter, \(\text{PCC}\), change as we
change our control parameter, \(p_m\)? First, we consider the case of
only two populations, \(N_p=2\). Here, the dispersal potential,
\(P(V_j|V_i)\), becomes irrelevant, as the fact that an individual
migrates means that it migrates to the other
population---i.e.~\(P(L_2|L_1)=1\) and \(P(L_1|L_2)=1\). Here, then,
\(p_m\) is the only parameter driving connectivity in the system. How
does the expected amount of synchrony between the two populations change
as we change the probability an individual migrates, \(p_m\)? In Figure
\ref{2pops_across_lambda}, we see \(\text{PCC}\) plotted as a function
of \(p_m\). Each point represents the mean value of \(\text{PCC}\)
across 50 replicates. Each panel of figure \ref{2pops_across_lambda} is
for different strengths of density-dependent regulation, \(\lambda\).

Each plot in figure \ref{2pops_across_lambda} is a phase transition
diagram, showing how synchrony changes as a function of migration
probability. Each show a similar functional form, as we see correlation
between the two populations maximized near \(p_m=0.5\). Intuitively,
this maximum makes sense: exchanging 50\% of the individuals between
populations in each time step leads to a well-mixed metapopulation.
Furthermore, since there is no local adaptation in this model, a
migration rate of \(p\) is functionally equivalent to a migration rate
of \(1 - p\).

We see that this is a continuous, or type-II phase transition---we don't
reach a point of \(p_m\) where the system suddenly jumps from
\(\text{PCC}= 0\) to \(\text{PCC}=1\). Instead, we see that the expected
level of synchrony drops off as we move away from \(p_m=0.5\). Further,
as we increase \(\lambda\), we see this peak become 'narrower', in that
values near \(p_m = 0.5\) have lower expected \(PCC\) as \(\lambda\)
gets larger. Why does increasing the strength of density dependent
regulation, \(\lambda\), narrow the curve? As \(\lambda\) increases,
values of \(p_m\) that enable in-between levels of synchrony for low
\(\lambda\) have their moderate synchrony broken down by local
density-dependent regulation, unless the populations are at a value of
\(p_m\) such that they synchronized tightly enough that they are both
experiencing the same force of density-dependent regulation, meaning
moving either up or down towards \(K_i\), at the same time.

In figure \ref{2pops_across_sigma}, we see transition diagrams for
\(N_p=2\) across demographic stochasticity, \(\sigma_p\). Here, we see that amount of demographic stochasticity doesn't
dramatically alter the shape of the synchrony transition. This leaves us
with a few questions---why would this phase transition be centered
around \(p_m = 0.5\)? Here we suggest the following hypothesis: at
\(p_m=0.5\), the composition of each population at any time is equally
composed of descendants from each population---this enables even-mixing
of demographic stochasticity within each population, which maximizes
synchrony. We make this case further in \emph{Synchrony due to
Even-Mixing of Local Stochasticity}. Why does the strength of
density-dependence, \(\lambda\), narrow the region of \(p_m\) where
synchrony is maximized, but \(\sigma_p\) doesn't? We suggest that this
is due to the small amount of subdivision present, which we'll examine
in the next section.

### Effects of Demography and Landscape Connectivity

Now, we vary demographic parameters, \(N_p\), \(K\), \(\sigma_p\) , and
\(\lambda\) , to determine how shifts in demography change the
functional form of the transition across \(p_m\). In figure
\ref{subdiv_across_lambda}, we vary the strength of density dependence,
\(\lambda\), across different numbers of populations, \(N_p\).

Here we see that both \(\lambda\) and \(N_p\) have effects on the
structure of the curve. Like in the two-population model, increasing
\(\lambda\) narrows the peak around which \(p_m\) values produce
synchrony. Let \(m_{max}\) be the value of migration that maximizes
synchrony. We see that as subdivision, \(N_p\), increases, we see the
transition curve narrows around increasingly high values of \(m_{max}\).
This supports with our hypothesis of even-mixing, which we'll explore
more later. In figure \ref{subdiv_across_lambda}, each color represents
a different value of isolation-by-distance strength, \(\alpha\). We see
that changing \(\alpha\) doesn't change the shape of the curve, but
instead just flattens it---decreasing the maximum value of synchrony
across the \(p_m\) gradient. This is intuitive---as connectivity
decreases, it becomes less likely to produce global synchrony at any
\(p_m\) .

Next we varied the total carrying capacity, \(K\), across different
numbers of populations, \(n_p\) (Figure \ref{subdiv_across_k}).
In Figure \ref{subdiv_across_k}, the number of populations has the same
effect as above, but carrying capacity doesn't alter the shape of this
curve, which is unsurprising given that our model considers the variance
of local stochasticity to be a proportion of \(K\).

Now, we shift \(\sigma_p\). (Figure
\ref{subdiv_across_sigma}). Here, we see that the magnitude of
\(\sigma_p\) narrows the curve, as larger amounts of local stochasticity
drown-out synchrony at values near, but not at, \(m_{max}\). Here we
observe the same effect of subdivision, and similar narrowing around
\(m_{max}\) . Similar to the two-population model, more variability
locally does mean less synchrony at same migration levels, except this
effect is strengthen by increasing subdivision. We suggest that this is
because increasing subdivision increases the number of stochastic
demographic events that happen every timestep, which inherently
increases the variance in the change in abundances during any interval.

Clearly, we see landscape subdivision, represented by \(N_p\), as having
the most prominent effect on the shape of the transition curve. The more
landscape subdivision there is, the higher migration has to be to enable
synchrony. Further, subdivision induces a qualitative shift in the shape
of this curve, from being only convex, (e.g., figure
\ref{subdiv_across_sigma}A), to having both concave and convex regions
(e.g., figure \ref{subdiv_across_sigma}D). As subdivision increases, the
transition curves exhibit more 'critical' behavior, meaning they reach a
tipping point value of \(p_m\) where synchrony starts to increase very
suddenly (figure \ref{subdiv_across_sigma}(A-D)). We then considered how \(\text{PCC}\) changes across both \(p_m\) and
\(\alpha\) with different dispersal kernels. Figure \ref{kernels} shows
that the dispersal kernel has significant effects on the region where
global synchrony is established. This means that different structures of
resistance features lead to different outcomes in the ability to build
up global synchrony.

### Synchrony due to Even-Mixing of Local Stochasticity


The Moran effect claims that the synchrony of populations across space
is proportional to the covariance of their environmental conditions
(Ranta et al. 1995, Bjørnstad et al. 1999). Here we make the case that
what drives synchrony across space is the 'even-mixing' of local
stochasticity. As is evidenced by figures \ref{2pops_across_sigma} and
\ref{2pops_across_lambda}, in a two population scenario, synchrony is
maximized near \(p_m =0.5\). We suggest that this is because the
population at any given time step is an even mix of descendants from
each population, and thereby averages out the demographic stochasticity
across all populations, leading to synchronized dynamics, as the change
in each population at every time is the averaged value of local change
across all populations. If this were the case, we would expect the value
of migration which maximizes synchrony,
\(m_{max}=\text{argmax}_{p_{m}} \text{PCC}(p_m)\) to be the value such that the
probability of an individual reproduces in population \(j\) given they
were born in population \(i\), \(\Phi_{ij}\), to be equal for all \(j\).
In the case that \(P(V_j | V_i)\) is uniform, i.e.~\(\alpha = 0\), this
would mean setting \(p_m = m_{max}= 1  - \frac{1}{N_p}\) would result in a
\(\Phi_{ij}\) that evenly mixes individuals each timestep. In figure
\ref{even_mixing}, we can see this function is plotted in black against
simulated data points (purple).

This indicates that synchrony is enabled when local stochasticity is
averaged out by dispersal. The Moran effect suggests that population
synchrony across space is proportional to covariance in environment.
However, dispersal can substitute for covariance in the environment when
it results in the admixture of individuals from populations in
proportion to the environmental covariance. Further, we see in
\ref{even_mixing} that increasing the strength of isolation-by-distance
makes this relationship weaker, as different subsets of the total set of
populations form synchronized dynamics (see the final section,
\emph{Mesopopulation}).


Consider the change in size of population \(i\) size across all
timesteps, \(\Delta_i = [\Delta_i(t) - \Delta_i(t-1)] \ \forall \ t\).
How does the global synchrony of the metapopulation change the variance
of this distribution?

In figure \ref{variance_over_m}, we see how the variance of \(\Delta\),
\(V(\Delta)\), changes with \(p_m\). We see that the overall variance in
the change in abundance over time is reduced as \(p_m\) increases, in a
pattern strikingly similar to the way \(PCC\) changes over \(p_m\). In
panel (b), we see that \(V(\Delta)\) is negatively correlated with
\(PCC\), and that this relationship becomes stronger as \(\sigma_p\)
increases. This indicates that synchrony reduces the values of
\(V(\Delta)\). Now consider the value of \(p_m\) which minimizes
\(V(\Delta)\). How correlated is this with the value of \(p_m\) that
maximizes synchrony, \(m_{crit}\) ? Consider figure
\ref{delta_pcc_corr}.


We know from theory that reducing that variance of \(N_t - N_{t-1}\)
reduces extinction risk (Lande et al. 2003, Melbourne and Hastings
2008). It has been suggested in the past the spatial synchrony can
increase the risk of extinction (Matter and Roland 2010, Heino et al.
1997). However, our evidence here runs counter to that
claim---increasing synchrony decreases the variance of the change in
abundance over time, \(V(\Delta)\), which is key in maximizing the
probability of a populations persistence (Lande et al. 2003). We suggest
that prior studies are flawed in their conclusion that synchrony
inherently increases the probability of global extinction as they do not
consider the correlation of between synchronous dynamics and reduced
variance in local abundances over time.

The question remains---does this diffusion model accurately describe the
actual dynamics of dispersal in ecological systems? Dispersal is a
stochastic process, and diffusion assumes that each time step, the
dispersal between pops in the expected value of that process. Here we
present a method for using our representation of landscape connectivity
to simulate stochastic dispersal, and compare the stochastic dispersal
model to the diffusion model.

### Stochastic Dispersal Model


We use the same construction of landscape connectivity in the random
dispersal model as the diffusion model---that is that each individual
migrates from its original population with probability \(P(m)\), and the
conditional distribution of where migrations go, \(P(V_j|V_i)\).
However, rather than using fixed coefficients, \(\Phi_{ij}\), to
represent dispersal, each generation we draw the number of total
migrations from population \(i\), \(N_{mi}\), from a Binomial
distribution, \(N_{mi} \sim \text{Binomial}(N_i,p_m)\). Then, for each
migrant \(\{1,2,N_{mi}\}\), the population \(j\) the migrant goes is
drawn directly from the distribution \(P(V_j|V_i)\)


First we consider the difference in synchrony transitions across a
migration gradient between using stochastic migration (\emph{Stochastic
Dispersal Model} above) vs.~the diffusion model (equation
\ref{diffusion_model}). Figure \ref{stoch_vs_determ_grid} shows phase
transition curves for both the diffusion (dark blue) and stochastic
(light blue) models across different values of \(N_p\) and \(\sigma_p\). We see that as the strength of demographic stochasticity, \(\sigma_p\),
increases, the difference in PCC between the deterministic model and the
stochastic model decreases. This is evident of a transition in which
stochastic mechanism, demographic stochasticity or dispersal
stochasticity, is driving the variation between populations at any fixed
time.



In cases where the amount of demographic stochasticity is low (Figure
\ref{stoch_vs_determ_grid}A), migration events are the primary source of
the variability in the size of each population over time. When we model
dispersal deterministically, there is no variability in migration each
timestep. So, there is more correlation across populations in the
deterministic than the stochastic model, where migration events occur
according to Monte Carlo sampling. However, as we increase the amount of
demographic stochasticity, \(\sigma_p\), we reach a point where the
variability in the abundance of each population over time is dominated
by demographic stochasticity within populations, as opposed to migration
events. When demographic stochasticity is the primary source of
variance, migration between populations, even if it is not distributed
exactly according to the dispersal potential at each time point, spreads
this stochasticity out across all populations. When migration
stochasticity is the primary source of variance, the abundances at each
population \(i\) are stable, except for the variance induced by
immigration and emigration events.

Figure \ref{stoch_vs_determ_surface} show that beyond some threshold
level of demographic stochasticity, both the deterministic and
stochastic dispersal model can be used to understand the effects of
dispersal and landscape structure on correlation between dynamics as the
temporal variance that would 'break down' correlations between
abundances is dominated by demography rather than the stochastic nature
of migration. We can better understand this transitions using the phase
diagram in Figure \ref{stoch_vs_determ_surface}b.


Figure \ref{stoch_vs_determ_surface} shows different two regimes---one
where the stochastic and diffusion model make the same predictions, and
one where they don't, highlighted in figure
\ref{stoch_vs_determ_surface}b. This indicates that as long as
demographic stochasticity is larger than \(\sigma_p = 0.05\), the
diffusion model and stochastic dispersal model make the same predictions
about metapopulation synchrony. In the migration dominated regime,
building up high synchrony isn't possible at any \(p_m\). However, in
the 'demographic stochasticity' region, the that stochastic migration
and diffusion models make the same prediction, and develop the synchrony
transitions we see in the previous section.

### discussion


Here, we present a way of measuring of \emph{functional connectivity}
using simulation models. We construct a model of diffusion that relates
to measurable values of resistance in real landscapes, and show that
this diffusion model can make accurate predictions about stochastic
dispersal at sufficiently high values of demographic stochasticity,
\(\sigma_p\).

We emphasize the importance of these types of simulation models in
measuring \emph{functional} connectivity. Given the constraints that
exist on conservation efforts, it is clear that we must make use of
limited resources in the most effective way possible if we want to
preserve biodiversity as it currently exists on Earth. Developing
corridors between existing habitat patches has seen extensive use as a
strategy in conservation (Beier 2012). Within this framework, the
question still remains---what corridors are the most effective to add?
The resources available to conservation are often tightly limited and as
a result being able to make the most effective decisions to preserve
biodiversity given the potential resources available is important. We
propose that simulation models, like we describe here, can be effective
in assessing functional landscape connectivity, and planning future
landscape development such that humans can live side-by-side with the
rest of Earth's inhabitants.


## thesis opening

> Nature is a mutable cloud, which is always and never the same.
> RW Emerson



### introduction


Life on Earth takes on an endless diversity of forms. Yet, the
characteristics that define 'life' impose parameters on the properties
that biological entities must exhibit, and constraints on how these
entities can change over time. These are the fundamental principles of
evolution and ecology---entities that reproduce themselves more than
average become more frequent, there is a limit on resources, and so on.
Over the billions of years life has been on this planet, these forces
have produced an astonishing diversity of forms and functions. The
forces that drive evolutionary and ecological processes do not occur on
a single scale---they emerge out of the interactions that occur across
all levels of spatial and temporal biological organization (Levin 1992).

Understanding how ecological processes change across space, within and
across scales, is central to the questions of ecology and evolution. The
spatial distribution of individuals is central to behavioral ecology,
the spatial distribution of species to biogeography, the spatial
distribution of genes to speciation, and so on. Further, the influence
of space on ecological processes has significant applied importance as
human activity has drastically altered the face of our planet in an
extremely short period of time (Bigelow and Borchers 2017, Vitousek
1997). Land-use change has shifted the amount and configuration of
Earth's habitats, and climate change is shifting the spatial
distribution of environmental factors and species' distributions
(Pereira et al. 2010, Thomas 2010, Loarie et al. 2009). This drastic
change in the structure of our planet's terrain has had overwhelmingly
negative effects on the biodiversity to which it is home (Haddad et al.
2015, Rands et al. 2010). This has, in turn, degraded ecosystem
functioning, and the services provided by ecosystem functioning, around
the globe (Tilman et al. 2014, Cardinale et al. 2012).

Historically, studies of the effects of landscape structure on
biodiversity have fallen under the broad umbrella of ''habitat
fragmentation'' (Collinge 2009). However, there has been significant
debate regarding what is meant by this term. The primary distinction
here is the difference between the word \emph{fragmentation} as it is
commonly used as a catchall to describe a combination of habitat loss
and ensuing subdivision, and \emph{fragmentation per se}, which is
purely the spatial separation or reconfiguration of the same amount of
habitat (Fahrig 2003). The effect of spatial subdivision independent of
habitat loss (fragmentation \emph{per se}) on biodiversity is still
hotly contested (Fahrig et al. 2019, Fletcher et al. 2018, Fahrig 2017,
Ewers and Didham 2006). However, it is abundantly clear that the
combined effects of habitat loss and subdivision have had negative
effects on the planet's biodiversity (Haddad et al. 2015). As a result,
a major focus on conservation efforts has become understanding and
predicting the simultaneous effects of habitat loss and subdivision on
ecosystem structure and stability (Fletcher and Fortin 2019).

In order to understand and predict the consequences of landscape change,
we first need models to bridge the gap between the data we can collect
and the inferences and predictions we wish to make about the world.
Before we can construct quantitative models to make predictions with
real data, we first need to conceptualize the process we are modeling in
space. Over the years, ecologists have considered many different ways of
representing the structure of space and its influence on ecological
processes, using a variety of frameworks and tools to represent
different processes across different scales. Here, we examine the role
that model construction plays in scientific epistemology to better
understand how models can be used and compared, and review the various
constructions of space ecological models have used in the past.


### what is a model


Science is fundamentally a theory of epistemology---a way of knowing.
Within the constraints of scientific epistemology, for a scientific
theory to be considered valid, it must be falsifiable through
observation, and for a theory to be disproven through observation, it
must make predictions that may or may not agree with observed reality
(Popper 1934). In this view, a scientific model can be seen as a
function---some ontological object, \(f\), that maps measurable input
conditions, \(\vec{x}\), to a predicted outcome, \(y=f(\vec{x})\).

Constructing models is inherently a creative act. Before we can
introduce any quantitative representation of a process, we need to
conceptualize what it is we should even be quantifying. In \emph{What is
Philosophy?}, Deleuze \& Guattari (1991) answer the eponymous question
by suggesting philosophy is the act of concept creation. They write:

\begin{quote}
In fact, the sciences, arts, and philosophies are all equally
creators\ldots{} Concepts do not wait for us ready-made, like celestial
bodies. There is no heaven for concepts. They must be invented,
fabricated, or rather created, and would be nothing without the
signature of those who create them. (Deleuze \& Guattari 1991)
\end{quote}

In this view, scienctific modeling, too, is an act of creation, not
discovery. The concepts we use to frame natural systems are not inherent
properties of nature. Especially in ecology, it often seems the atomic
unit is the individual, yet this ignores differences in that
individual's cells, driven by biochemical processes that are the product
of interactions molecules within those cells, and so on---there is not
natural or correct scale on which to model natural processes (Levin
1992), and the conceptual frameworks we use to model ecosystems are
tools created by the modeler. Just as Newtonian Gravity, General
Relativity, and the Principle of Least-Action all describe and predict
the same phenomena using entirely different conceptual frameworks
(Arkani-Hamed 2012, Feynman 1965), valid ecological models can be framed
in a variety of different ways.

Within scientific epistemology, there is implicitly a claim that some
explanations of the world are more valid than others. In order to
properly make this demarcation, we must ask: what constitutes a 'valid'
model? A model's ''correctness'' can measured as the difference between
its prediction, \(y\), and observed reality, \(\hat{y}\) (Jaynes and
Bretthorst 2003). However, no model can perfectly predict the world
around us. If there is not random variation in a process, there is at
minimum the error inherent to measurement. Further, all models have
information baked into them based on how they define \(f\), and how much
information is already contained in \(\vec{x}\) . Further, as we add
more parameters to a model it becomes harder to disprove that our
predictions \(y\) don't agree with \(\hat{y}\).

There is a long history of model comparison---the earliest frameworks
for model selection---Occam's Razor, parsimony, etc.---assert that
simpler models are better than more complicated models because they rely
on fewer assumptions. However, it is clear that more complicated models
can, in some cases, provide better predictive accuracy than simpler
models. To address this issue, most modern methods for model selection
have turned to information theory to differentiate models based on their
predictive capacity. Many modern methods for information theoretic model
selection---Minimum Description Length, AIC, BIC---revolve around the
heuristic that better models maximize that ratio of how much information
a model provides in predictive power to how much is built information
into the model structure (Jaynes and Bretthorst 2003, Stine 2004). Other
methods, like crossvalidation, aim to test the predictive accuracy of a
model by testing it on data it hasn't ''seen'' yet. (Konishi and
Kitagawa 2008). Either way, this provides criteria by which to assess
how models compare to one another in their capacity to explain natural
phenomena. However, what is actually meant by 'model' in practice varies
widely. We use models for a variety of things---inference,
hypothesis-testing, prediction---and for these different purposes we use
a different methods to construct \(f\).

Breiman (2001) partitions models into two types: data models and
algorithmic models. Both map input conditions to output conditions, but
the difference lies is in the approach we take to create \(f\).
Algorithmic models aim to construct \(f\) as an algorithm which
accurately predicts output conditions based on input conditions. The
algorithm tends to have little relation to the mechanisms producing the
data being modeled, but rather is designed with the aim of accurately
finding patterns in data---methods of this type tend to receive the
somewhat ambiguous label ''machine learning''. These models can be
exceptionally useful for prediction, but this comes at the cost that
they do not reliably provide information about the mechanisms producing
the data.

In contrast, data models attempt to model the way in which the data is
generated. We can further partition data models into statistical models
and process models. The vast majority of scientific studies use
statistical models (Breiman 2001), which conceptualize \(f\) by assuming
the output of \(f\) is some combination of its input conditions,
\(x_i\), each of which is drawn from an assumed distribution for each
observation. Models of this form have seen extensive use because they
are easily generalizable and can be applied to a variety of problems.
Further, by assuming that measured quantities follow distributions that
we can describe analytically, we are able to compose likelihood
functions which can then be used to fit models to data using a variety
of methods, both frequentist and Bayesian. In contrast, process models
aim to construct \(f\) to represent the hypothesized mechanism that
produces the data. This can be done in a variety of methods---for
example, \(f\) could be written as a stochastic differential equation,
as we will do in the next chapter, or \(f\) could be described as a set
of properties between agents in an individual-based model. Process
models can vary in the degree to which they represent the fidelity of
the actual process based on the scale and detail of representation
considered. However, this comes with the cost that, in general, process
models are much more difficult to fit data to than statistical models.
However, recent advances in Approximate Bayesian Computation (Beaumont
2010) make it feasible to fit data to complex simulation models which
cannot be described by an analytic likelihood function. This can give us
a way to test between mechanistic process models, given that we have a
reasonably small number of potential mechanisms we want to test.

Now, we turn to the history of spatial models in population and
community ecology to survey the the ways in which process models in
these domains have conceptualized space.

### A History of the Construction of Space in Ecology


#### TIBG

Nearly all of landscape ecology has its roots in the Theory of Island
Biogeography (TIBG, MacArthur and Wilson 1967). The TIBG modeled a
system of oceanic islands, each with a different size, corresponding to
resource levels. The primary motivation of the theory was to provide a
mechanistic explanation of the species area relationship, and so the
core of the TIBG relates the spatial structure of the islandscape---the
size of each island and the distances between them---to observed
patterns of species richness.

Although the TIBG was conceptualized for terrestrial communities on
oceanic islands, it quickly was applied elsewhere under the assumption
that many human-altered landscapes are well-approximated by an island
structure---isolated regions of homogeneous landscape separated by
inhabitable matrix (Haila 2002, MacArthur and Wilson 1967, Preston
1962). The analogy between islands and subdivided, patchy landscapes was
first made by Preston (1962), and is briefly invoked in the TIBG.
However, this analogy went on to strongly influence how landscape
ecologists modeled space in terrestrial landscapes in the future. Traces
of the central ideas of the TIBG---area as a proxy for resource
availability, richness as a product of an equilibrium between
colonization and extinction, that patches are internally
homogeneous---can be seen all throughout the models of landscape ecology
that followed.

#### Metapopulation theory


The metapopulation framework was introduced by Levins (1969)---who
originally defined a metapopulation as 'a population of populations'.
Metapopulation theory, like the TIBG, considers the dynamics of
occupancy due to colonization or extinction. Levins' model considers a
system of infinite populations, each with a fixed probability of
colonization, \(c\), or local extinction, \(e\) , each generation. In
this formulation, the proportion of populations occupied at a given
time, \(p\), is modeled as as

\[\frac{dp}{dt} = cp(1-p)-ep\]

From this, we can derive that the system will persist, i.e.~\(p \to 1\),
if and only if \(\frac{c}{e} >1\), and \(p\to0\) otherwise (Levins
1969). The aim of this model was not to be used to predict the
consequences of subdivision in an empirical system---rather, this is
what Okubo (1978) calls a ''toy model'': a way of examining the
consequences imposed by an oversimplified version of the dynamics in
question. In reality, stochasticity in colonization/extinction events
cause real systems to diverge from the deterministic predictions made by
Levins' model, and the spatially implicit structure of this model made
it difficult to assess the influence of landscape structure or use for
prediction in a real landscape.


Metapopulation theory was more formally applied to fragmented landscapes
by Hanski and Ovaskainen (Hanski 1994, Hanski and Ovaskainen 2000), who
adapted Levins' framework of a network of occupied/unoccupied patches,
and restricted it to a finite number of populations with
spatially-explicit locations, each with a unique probability of
colonization arising from the metapopulation's spatial structure. This
introduces more parameters---each population \(i\) has a spatial
coordinate in \(\mathbb{R}^2\), \((x_i, y_i)\), and an area associated
with it, \(A_i\). Here, like in the TIBG, area is still a proxy for the
resource availability in that patch, as the probability of a patch going
extinct in a generation is is inversely proportional to its area, and
directly proportional to its ability to serve as a source for
colonizers. Similarly, in a departure from Levins' model, the
probability of an unoccupied patch getting colonized during any timestep
is inversely proportional to how far away it is from occupied patches.
This relationship of isolation-by-distance (IBD), called the dispersal
kernel, was initially modeled as an exponential (Hanski 1994),
\(f(d_{ij})= \ e^{-\alpha d_{ij}}\), which has seen extensive use since.

What made Hanski and Ovaskainen's theory capable of interfacing with
real data is their use of incidence-function models (IFMs, Hanski 1994).
The value of the incidence function \(J_i\), for any population \(i\),
is the long run proportion of time that population \(i\) is occupied.
From this, one can compute the probability of changing from any state of
occupancy to any other state, which provides us with a likelihood
function to estimate parameters from occupancy data in real systems.
Much like the TIBG, this is based on the assumption that when the data
we collect is indicative of a system that has approached its long-term
equilibrium state This work enabled the extensive use of IFMs in
conservation (Risk et al. 2011, MacPherson and Bright 2011, Vos et al.
2000, Hanski et al. 1996). More recent metapopulation studies use
so-called Dynamical Models (Fletcher and Fortin 2019), which model
occupancy in space as a Bernoulli distribution, with weighted parameters
to account for isolation-by-distance/resistance, environmental variance,
or other covariates.


#### Sources and Sinks


Another theoretical output of metapopulation theory is the conceptual
framework of sources and sinks. Source-sink metapopulations emerged from
the theory of birth-immigration-death-emigration (BIDE) demographic
models (Pulliam 1988), the idea being that different locations in space
have differing levels of resource availability, and that as a result,
have different expected values of each of these parameters every
generation. Populations with more births than deaths and more emigrants
than immigrants are `sources', populations with higher deaths than
births are `sinks'. This conceptual framework has since spread outside
population ecology, and gone on to be influential across metacommunity
(Mouquet and Loreau 2003), population genetics (Gaggiotti 1996), and
coevolutionary theory (Thompson 2002).

Within both the metapopulation framework and the TIBG, it is assumed
that there isn't heterogeneity within patches, and that the region
between habitats is entirely inhospitable. However, these assumptions
would later be challenged by the increasing availability of data that
allowed ecologists to think about space continuously.

### lattice models


One natural limit of the above models is that ecological processes do
not occur in discrete space. Although continuous-space models have long
been used in theoretical studies (Haldane 1948, Hastings 1978, Okubo
1978), the difficulty inherent to both collecting 'continuous' spatial
data, plus the increased mathematical complexity induced by considering
processes in continuous space, long made such models impractical to
apply to an empirical system.

This changed due to two major developments: the increased availability
of remotely sensed land cover data and the onset of computational power
to feasibly run simulation models that well-approximate continuous
space. The advent of remote sensing imagery enabled construction of
global land-cover maps, which function as approximations of continuous
space on large scales. In response, landscape research focused on
studying various aspects of patch geometry in raster data (McGarigal and
Marks 1995).

This, plus the continued growth of computational power, paved the way
for models using rasters to approximate continuous space, meaning we
were no longer limited in our ability to model continuous space with the
tools of analytical math. Lattice-based simulation models have been
applied to many questions, including the theory of percolation in
habitat loss (Bascompte and Sole 1996), evolutionary rescue models
(Boeye et al. 2013), epidemiology models (Jeltsch et al. 1997),
coevolutionary models (Sisterson and Averill 2004), adaptive radiation
(Gavrilets and Vose 2005), predator-prey models (Matsuda et al. 1992),
and so on.

These developments led us to more complex conceptual models of landscape
structure. The relationship of different land cover types in relation to
one another marks a significant shift away from the habitat is either
suitable-or-unsuitable binary that has dominated landscape ecology for
many years, and to other models including the so-called mosaic model
which considers all elements of the matrix as important to understanding
landscape structure (Fortin \& Fletcher 2019, Wiens 1995).

### resistance and connectivity


The field of landscape genetics, introduced by Manel et al.~(2003), has
sought to synthesize an understanding of landscape structure with
population genetic models using the recent availability of
next-generation sequencing technology. This field has contributed many
conceptual frameworks to the study of space, including idea of
isolation-by-resistance (IBR, McRae 2006, McRae et al. 2008). IBR argues
that different landscape features, typically represented as different
land cover types, impose different strengths of ''resistance'' to
dispersal or movement. Each cell in a raster landscape, called a
resistance surface, is modeled as a resistor, and the minimum resistance
path between any two points in the raster can be estimated using circuit
theory (Spear et al. 2010). More recently models of gene flow have been
used to validate resistance surfaces (Mateo-Sánchez et al. 2015), and
construct them from from a combination of genetic and landscape data
(Peterman 2018).

The concept of landscape connectivity has seen much recent interest in
conservation ecology (Robertson et al. 2018, Mitchell et al. 2013,
Carroll et al. 2012, Krosby et al. 2010). The effect of connectivity on
ecological processes has been clear since the concept was first
introduced (Turner 1989, Taylor et al. 1993), however, the theory of
resistance surfaces has proven an invaluable tool in quantifying
connectivity (Kool et al. 2013). The use of spatial graphs in
connectivity models has also seen recent interest, as they provide a
generalizable framework to study pattern and process in landscapes
across different scales (Chubaty et al. 2020, Dale and Fortin 2010,
Minor and Urban 2008, Urban and Keitt 2001).


## conclusion

Here, we have focused on the various ways that spatial models have been
constructed in ecology---however, as mentioned earlier, scientists use
models to serve a number of different functions, and different ways of
modeling space have different utility in different circumstances. In the
next chapter, we restrict our focus to simulation models. We suggest
that when planning efforts to restore landscape connectivity, there is
immense value in using simulation models to predict the effects of
potential corridors on functional connectivity (Epperson et al. 2010).
