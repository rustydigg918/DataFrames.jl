import Base: @deprecate

@deprecate DataFrame!(args...; kwargs...) DataFrame(args...; copycols=false, kwargs...)

# TODO: remove these definitions in year 2021
by(args...; kwargs...) = throw(ArgumentError("by function was removed from DataFrames.jl. " *
                                             "Use the `combine(groupby(...), ...)` or `combine(f, groupby(...))` instead."))

aggregate(args...; kwargs...) = throw(ArgumentError("aggregate function was removed from DataFrames.jl. " *
                                                    "Use the `combine` function instead."))

export categorical, categorical!
function CategoricalArrays.categorical(df::AbstractDataFrame,
                                       cols::Union{ColumnIndex, MultiColumnIndex};
                                       compress::Union{Bool, Nothing}=nothing)
    if compress === nothing
        compress = false
        categoricalstr = "categorical"
    else
        categoricalstr = "(x -> categorical(x, compress=$compress))"
    end
    if cols isa AbstractVector{<:Union{AbstractString, Symbol}}
        Base.depwarn("`categorical(df, cols)` is deprecated. " *
                     "Use `transform(df, cols .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical)
        return transform(df, cols .=> (x -> categorical(x, compress=compress)), renamecols=false)
    elseif cols isa Union{AbstractString, Symbol}
        Base.depwarn("`categorical(df, cols)` is deprecated. " *
                     "Use `transform(df, cols => $categoricalstr, renamecols=false)` instead.",
                     :categorical)
        return transform(df, cols => (x -> categorical(x, compress=compress)), renamecols=false)
    else
        Base.depwarn("`categorical(df, cols)` is deprecated. " *
                     "Use `transform(df, names(df, cols) .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical)
        return transform(df, names(df, cols) .=> (x -> categorical(x, compress=compress)), renamecols=false)
    end
end

function CategoricalArrays.categorical(df::AbstractDataFrame,
                                       cols::Union{Type, Nothing}=nothing;
                                       compress::Bool=false)
    if compress === nothing
        compress = false
        categoricalstr = "categorical"
    else
        categoricalstr = "categorical(x, compress=$compress)"
    end
    if cols === nothing
        cols = Union{AbstractString, Missing}
        Base.depwarn("`categorical(df)` is deprecated. " *
                     "Use `transform(df, names(df, $cols) .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical)
    else
        Base.depwarn("`categorical(df, T)` is deprecated. " *
                     "Use transform(df, names(df, T) .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical)
    end
    return transform(df, names(df, cols) .=> (x -> categorical(x, compress=compress)), renamecols=false)
end

function categorical!(df::DataFrame, cols::Union{ColumnIndex, MultiColumnIndex};
                      compress::Union{Bool, Nothing}=nothing)
    if compress === nothing
        compress = false
        categoricalstr = "categorical"
    else
        categoricalstr = "(x -> categorical(x, compress=$compress))"
    end
    if cols isa AbstractVector{<:Union{AbstractString, Symbol}}
        Base.depwarn("`categorical!(df, cols)` is deprecated. " *
                     "Use `transform!(df, cols .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical!)
        return transform!(df, cols .=> (x -> categorical(x, compress=compress)), renamecols=false)
    elseif cols isa Union{AbstractString, Symbol}
        Base.depwarn("`categorical!(df, cols)` is deprecated. " *
                     "Use `transform!(df, cols => $categoricalstr, renamecols=false)` instead.",
                     :categorical!)
        return transform!(df, cols => (x -> categorical(x, compress=compress)), renamecols=false)
    else
        Base.depwarn("`categorical!(df, cols)` is deprecated. " *
                     "Use `transform!(df, names(df, cols) .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical!)
        return transform!(df, names(df, cols) .=> (x -> categorical(x, compress=compress)), renamecols=false)
    end
end

function categorical!(df::DataFrame, cols::Union{Type, Nothing}=nothing;
                      compress::Bool=false)
    if compress === nothing
        compress = false
        categoricalstr = "categorical"
    else
        categoricalstr = "(x -> categorical(x, compress=$compress))"
    end
    if cols === nothing
        cols = Union{AbstractString, Missing}
        Base.depwarn("`categorical!(df)` is deprecated. " *
                     "Use `transform!(df, names(df, $cols) .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical!)
    else
        Base.depwarn("`categorical!(df, T)` is deprecated. " *
                     "Use `transform!(df, names(df, T) .=> $categoricalstr, renamecols=false)` instead.",
                     :categorical!)
    end
    return transform!(df, names(df, cols) .=> (x -> categorical(x, compress=compress)), renamecols=false)
end
