export Parameter, AlgorithmicParameter

export value, domain, name, set_value!, find, lower_bounds, upper_bounds, values, input_types

"""`AbstractParameter`

An Abstract type that superseeds the other parameter types.
"""
abstract type Parameter{T} end

"""`AlgorithmicParameter`

Child type of `Parameter` that exposes a specific hyperparameter.
It contains specific fields that can be given to `NOMAD`.

"""
mutable struct AlgorithmicParameter{T, D <: AbstractDomain{T}} <: Parameter{T}
  value::T
  domain::D
  name::String
  function AlgorithmicParameter(value::T, domain::AbstractDomain{T}, name::String) where {T}
    check_value(domain, value)
    new{T, typeof(domain)}(value, domain, name)
  end
end

"""Returns the current value of a parameter."""
value(parameter::AlgorithmicParameter{T}) where {T} = parameter.value

domain(parameter::AlgorithmicParameter{T}) where {T} = parameter.domain

"""Returns the name of a parameter."""
name(parameter::AlgorithmicParameter{T}) where {T} = parameter.name

function check_value(domain::AbstractDomain{T}, new_value::P) where {T, P <: Real}
  T(new_value) ∈ domain || error("value should be in domain")
end

"""Set value of an algorithmic parameter."""
function set_value!(parameter::AlgorithmicParameter{T}, new_value::F) where {T, F <: AbstractFloat}
  parameter.value = new_value
end

"""Find a parameter in a list by its name."""
function find(parameters::AbstractVector{P}, param_name) where {P <: AlgorithmicParameter}
  idx = findfirst(p -> p.name == param_name, parameters)
  isnothing(idx) || return parameters[idx]
  return
end

"""Function that returns lower bounds of each parameter."""
function lower_bounds(parameters::AbstractVector{P}) where {P <: AlgorithmicParameter}
  [lower(domain(p)) for p ∈ parameters]
end

"""Function that returns upper bounds of each parameter."""
function upper_bounds(parameters::AbstractVector{P}) where {P <: AlgorithmicParameter}
  [upper(domain(p)) for p ∈ parameters]
end

"""Function that returns a vector of current parameter values."""
function values(parameters::AbstractVector{P}) where {P <: AlgorithmicParameter}
  [value(p) for p ∈ parameters]
end
