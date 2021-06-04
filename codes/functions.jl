function cr_averse(θ, data)
    N_A = θ[1]
    N_B = θ[2] 
    α = θ[3]
    p_1 = θ[4] 
    p_2a = θ[5]
    p_2b = θ[6]
    
    x_11a = data[1]
    x_10a = data[2]
    x_01a = data[3]
    x_11b = data[4]
    x_10b = data[5]
    x_01b = data[6]
    x_0a = x_11a + x_10a + x_01a
    x_0b = x_11b + x_10b + x_01b
    
    res = N_A*log(N_A) - N_A  + 
          N_B*log(N_B) - N_B  - 
         (N_A - x_0a)*log(N_A - x_0a) + (N_A - x_0a) - 
         (N_B - x_0b)*log(N_B - x_0b) + (N_B - x_0b)  + 
          x_11a*log((1-α)*p_1*p_2a) + x_11b*log((1-α)*p_1*p_2b) + 
          x_10a*log(p_1*(α + (1-α)*(1-p_2a))) + x_10b*log(p_1*(α + (1-α)*(1-p_2b))) + 
          x_01a*log((1-p_1)*(α + (1-α)*p_2a)) + x_01b*log((1-p_1)*(α + (1-α)*p_2b)) + 
         (N_A-x_0a)*log((1-α)*(1-p_1)*(1-p_2a)) +  (N_B-x_0b)*log((1-α)*(1-p_1)*(1-p_2b))
    
    return(-res)
end

function cr_averse_optimize(data)
    
    x_11a, x_10a, x_01a, x_11b, x_10b, x_01b =  data
    x_1_a = x_11a+x_10a
    x_1_b = x_11b+x_10b
    x_0a = x_11a + x_10a + x_01a
    x_0b = x_11b + x_10b + x_01b
    N_A_naive = (x_11a+x_10a)*(x_11a+x_01a)/x_11a
    N_B_naive = (x_11b+x_10b)*(x_11b+x_01b)/x_11b
    
    model = Model(Ipopt.Optimizer)
    set_optimizer_attribute(model, "print_level", 0)
    @variable(model, x_0a <= N_A <= N_A_naive, start = N_A_naive/2)
    @variable(model, x_0b <= N_B <= N_B_naive, start = N_B_naive/2)
    @variable(model, 0.0001 <= p_1 <= 0.9999, start = 0.1)
    @variable(model, 0.0001 <= α <= 0.9999, start = 0.1)
    @variable(model, 0.0001 <= p_2a <= 0.9999, start = 0.1)
    @variable(model, 0.0001 <= p_2b <= 0.9999, start = 0.1)
    @NLobjective(model, Min, 
                        - (N_A*log(N_A) - N_A  + N_B*log(N_B) - N_B  -  
                            (N_A - x_0a)*log(N_A - x_0a) + (N_A - x_0a) - 
                            (N_B - x_0b)*log(N_B - x_0b) + (N_B - x_0b)  + 
                            x_11a*log((1-α)*p_1*p_2a) + x_11b*log((1-α)*p_1*p_2b) + 
                            x_10a*log(p_1*(α + (1-α)*(1-p_2a))) + x_10b*log(p_1*(α + (1-α)*(1-p_2b))) + 
                            x_01a*log((1-p_1)*(α + (1-α)*p_2a)) + x_01b*log((1-p_1)*(α + (1-α)*p_2b)) + 
                            (N_A-x_0a)*log((1-α)*(1-p_1)*(1-p_2a)) +  (N_B-x_0b)*log((1-α)*(1-p_1)*(1-p_2b)))
                        ) 
    optimize!(model)
    return [value(N_A), value(N_B), value(α), value(p_1), value(p_2a), value(p_2b)]
end

## add different variable and level
function create_data(data, quarter::Symbol, quarter_days::Symbol, days::Int, var::Symbol, var_lev)
    out_df = filter(quarter => ==(true), data)
    out_df = filter(quarter_days => <=(days), out_df)
    out_df = unique(out_df[:,[:source, :id_unit, var]])
    out_df[!, :n] .= 1
    out_df = unstack(out_df, [:id_unit, var], :source, :n)
    out_df.cbop = coalesce.(out_df.cbop, 0)
    out_df.pracuj = coalesce.(out_df.pracuj, 0)
    out_df[!, :var_cat] .= ifelse.(out_df[:, var] .== var_lev, "D", "SM")
    out_df = groupby(out_df, [:var_cat, :cbop, :pracuj])
    out_df = combine(out_df, nrow => :count)
    sort!(out_df, [:var_cat, :cbop, :pracuj], rev = true) 
    return(out_df)
end    

function cr_averse_analysis(data, quarter::Symbol, quarter_days::Symbol, days::Int, var::Symbol, var_lev,
                            bootstrap = false, bootstrap_samples = 500, verbose = true)
    
    data_optim = create_data(data, quarter, quarter_days, days, var, var_lev)
    θ̂ = cr_averse_optimize(data_optim.count)
    
    if verbose 
        println("Population size: ", θ̂[1]+θ̂[2])
    end
    
    ## check gradient
    ∇θ̂ = ForwardDiff.gradient(x -> cr_averse(x, data_optim.count), θ̂)
    
    if verbose
        println("Gradient: ", sum(abs.(∇θ̂)))
    end
    
    hess_θ̂ = ForwardDiff.hessian(x -> cr_averse(x, data_optim.count), θ̂)
    θ̂_se = sqrt.(diag(inv(hess_θ̂)))
    
    ## bootstrap
    
    if bootstrap 
        
        println("Bootstrap started")
    
        x_11a, x_10a, x_01a = data_optim.count[1:3]
        x_00a = θ̂[1] - (x_11a + x_10a + x_01a)
        p_a = [x_11a;x_10a;x_01a;x_00a] ./ θ̂[1]

        x_11b, x_10b, x_01b = data_optim.count[4:6]
        x_00b = θ̂[2] - (x_11b + x_10b + x_01b)
        p_b = [x_11b;x_10b;x_01b;x_00b] ./ θ̂[2]
    
        B = bootstrap_samples
        boot_estim_results = zeros(B, 6)
        for b in 1:B
            Random.seed!(b)
    
            data_a = rand(Multinomial(Int(ceil(θ̂[1])), p_a))
            data_b = rand(Multinomial(Int(ceil(θ̂[2])), p_b))
            boot_estim_results[b,:] = cr_averse_optimize(vcat(data_a[1:3], data_b[1:3]))
        end
    
        return(θ̂, θ̂_se, boot_estim_results)
    end
    
    return(θ̂, θ̂_se)
end


## for simulation study
function sample_from_n(N, α, p_1, p_2, samps)
   p_11 = (1-α)*p_1*p_2 
   p_10 = α*p_1 + (1-α)*p_1*(1-p_2)
   p_01 = α*(1-p_1)+(1-α)*(1-p_1)*p_2
   p_00 = (1-α)*(1-p_1)*(1-p_2)
   p = [p_11, p_10, p_01, p_00]
   return rand(Multinomial(N, p), samps)
end
