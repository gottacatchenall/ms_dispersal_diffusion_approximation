---
bibliography: [references.bib]
---

# Introduction

Human activity is rapidly altering our planet, leaving Earth's habitats
fragmented and patchy. Understanding the effects of this change on ecological
processes remains a fundamental goal of landscape ecology. It us well
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

Why is it important we understand when dispersal is a valid approximation of dispersal?
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
parameters. We show that what distinguishes these regimes is whether the primary
source of variation in population dynamics is either dispersal or demography.

# A model of metapopulation dynamics

Here, we present a model of metapopulation dynamics on spatial graphs.
This model contains three parts: a model of landscape connectivity, a model of
local population dynamics, and a model of dispersal. We use this model to
simulate time-series of metapopulation abundances using both diffusion and
stochastic models of dispersal, and then measure the synchrony of population
dynamics between populations. By comparing the synchrony created by stochastic
dispersal and diffusion models, we show there are two distinct regimes: a regime
where diffusion well approximates stochastic dispersal, and a regime where it
does not.


## Landscape connectivity model

Spatial graphs have long been used to model a system of habitat patches in a
landscape [dale_graphs_2010, minor_graph-theory_2008, urban_landscape_2001].
Here, we use a model of a landscape, represented as a set of locations $L$ in a
spatial graph $G$, where the edges represent dispersal between populations. To
describe how the edges of this network describe dispersal, we choose to model
landscape connectivity as a combination of two different factors: the
probability than any individual migrates during its lifetime, $m$, and the
conditional distribution over spatial nodes of where an individual goes ($j \in
L$), given both that it migrates $m$ and where it started ($i \in L$), which we
call the dispersal potential and denote

$$\Phi_{ij} =  P(i \to j | m)$$

The dispersal potential can be modeled several ways. In empirical systems, the
relative cost of movement from one point to another is often estimated with
resistance surfaces [spear_use_2010]. Here we model the dispersal potential
using isolation-by-distance (IBD), which assumes the relative probability of
dispersal from location $i$ to location $j$ is inversely proportional to the
distance between them, $d_{ij}$, and the strength of this isolation-by-distance
relationship, $\alpha$, which is treated as an intrinsic value of a species
dispersal capacity.

The form of the IBD relationship, called the dispersal kernel
[grilli_metapopulation_2015, hanski_practical_1994], we consider an
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

## Local population dynamics model

## Dispersal Models

### Stochastic Dispersal

### Diffusion


# Results

# Discussion



# References
