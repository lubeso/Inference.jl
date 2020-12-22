### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 2e43cbb6-4421-11eb-300a-75a8960cba3d
abstract type Distribution end

# ╔═╡ 0662de9c-4489-11eb-2c09-3fbbe5767dbb
begin
	
	# declare Distribution methods
	
	Base.iterate(p::Distribution, i::Int) = iterate(p.p, i)
	
	Base.iterate(p::Distribution) = iterate(p.p)
	
	Base.length(p::Distribution) = length(p.p)
	
	Base.getindex(p::Distribution, x) = get(p.p, x, 0)
	
	Base.keys(p::Distribution) = keys(p.p)
	
end

# ╔═╡ 7530335e-441a-11eb-1c57-27bb1dcecabc
md"""

> $$\Large \mathcal{P} \triangleq \{ p(\cdot; \theta) : \theta \in \Theta \}$$
>
> Distribution space
> ---
>
> Define set $\mathcal{P}$ as the collection of all probability distributions.
> Emphasizing generality, this set definition describes all of the possible 
> models to describe the behavior of phenomena (in our case, random variables).
> To quantify our understanding of the nature of events, we turn to the 
> probability distribution.
"""

# ╔═╡ eb17f3cc-4488-11eb-0561-6b8c64ed0660
md"""---"""

# ╔═╡ 192a9d4e-441d-11eb-18ac-1b2895e954f8
md"""
> $$\large \begin{align*}
> \mathcal{P} &= \mathcal{P}_M \cup \mathcal{P}_J \cup \mathcal{P}_C, \text{ where} \\
> \mathcal{P}_M &\triangleq \{p(\cdot; \pmb{\theta}(X)); 
> 	\pmb{\theta}(X) \in \pmb{\Theta}(X)\}, \\ \\
> 			   \mathcal{P}_J &\triangleq \{p(\cdot; \pmb{\theta}(X_1^n);
> 	\pmb{\theta}(X_1^n) \in \pmb{\Theta}(X_1^n)\}, \\ \\
> 			   \mathcal{P}_C &\triangleq \{p(\cdot; \pmb{\theta}(X|Y));
> 	\pmb{\theta}(X|Y) \in \pmb{\Theta}(X|Y)\} \end{align*}$$
>
> ### Distribution subspaces
> ---
> Specifically, the distribution space is composed of three categories
> of probability distributions:
> 
> 1. __Marginal distribution__ $-$ describes a single random variable $X$
>
> 2. __Joint distribution__ $-$ describes a collection of random variables $X_1,\dots,X_n$
>
> 3. __Partial__ _or_ __Conditional distribution__ $-$ describes a single random variable $X$ given the random variable $Y$
>
> To begin, we emphasize that the collection of random variables $X_1,\dots,X_n$
> can be conceptualized instead as a single random variable $X_1^n \triangleq 
> (X_1,\dots,X_n)$. Our development of probability distributions begins with
> a univariate focus, and readily extends into a multivariate analysis.
"""

# ╔═╡ 3bd0c82e-441c-11eb-18a3-6b893e733f6a
mutable struct Marginal <: Distribution 

	p::AbstractDict

	Marginal(p::AbstractDict) = new(p)

	Marginal() = new(Dict())

end

# ╔═╡ 0af1b628-4480-11eb-2fd0-9941429c9de8
function Base.show(io::IO, ::MIME"text/plain", p::Marginal)
	
	𝒳 = sort(collect(keys(p))); m = length(𝒳)
	
	if m <= 3
		
		output = ["Marginal distribution:\n   ",
				  ["$θᵢ, x = $aᵢ\n   " for (aᵢ, θᵢ) ∈ p]...]
		
	elseif m > 3
		
		(a₁, a₂, aₘ) = (𝒳[1], 𝒳[2], 𝒳[m])
		(θ₁, θ₂, θₘ) = (p[a₁], p[a₂], p[aₘ])
		
		output = ["Marginal distribution:\n   ",
				  "$θ₁, x = $a₁\n   ",
				  "$θ₂, x = $a₂\n   ",
				  "...\n   ",
				  "$θₘ, x = $aₘ\n   "]
		
	end
	
	print(io, output...)
	
end

# ╔═╡ b92053a2-4422-11eb-0ef7-c117d54e6ca5
md"""
> $$\large p_X(x;\pmb{\theta}(X)) = \begin{cases}
> \theta_1(X), & x = \texttt{a}_1, \\
> \theta_2(X), & x = \texttt{a}_2, \\
>  &\vdots \\
> \theta_m(X), & x = \texttt{a}_m \end{cases}$$
> ### Marginal distributions
"""

# ╔═╡ d30cb11a-43dd-11eb-299a-85f283d89cb2
p = Marginal(Dict(
		:a₁ => :θ₁, 
		:a₂ => :θ₂, 
		:a₃ => :θ₃, 
		:aₘ => :θₘ)
	)

# ╔═╡ 8f1f6bc6-4425-11eb-024c-c99a562ce2f6
md"""---"""

# ╔═╡ 3bbaf440-4421-11eb-26dc-9b88f155f5c4
mutable struct Joint <: Distribution 
	
	p::AbstractDict
	
	Joint(p::AbstractDict) = new(p)
	
	Joint() = new(Dict())
		
end

# ╔═╡ abceaea0-4482-11eb-2462-0f3ce0c40ef9
function Base.show(io::IO, ::MIME"text/plain", p::Joint)
	
	𝒳₁ⁿ = sort(collect(keys(p))); (m, n) = length.([𝒳₁ⁿ, 𝒳₁ⁿ[1]])
	
	if m <= 3
		
		x₁ⁿ = n == 2 ? "(x₁, x₂)" : "(x₁, x₂, x₃)"
		
		f = n == 2 ? 
			x₁ⁿ -> "($(x₁ⁿ[1]), $(x₁ⁿ[n]))" : 
			x₁ⁿ -> "($(x₁ⁿ[1]), $(x₁ⁿ[2]), $(x₁ⁿ[n]))"
		
		output = ["Joint distribution:\n   ",
				  ["$θᵢ, $x₁ⁿ = $(f(aᵢ))\n   " for (aᵢ, θᵢ) ∈ p]...]
		
	elseif m > 3
		
		x₁ⁿ = "(x₁, ..., xₙ)"
		
		f = x₁ⁿ -> "($(x₁ⁿ[1]), ..., $(x₁ⁿ[n]))"
		
		(a₁, a₂, aₘ) = (𝒳₁ⁿ[1], 𝒳₁ⁿ[2], 𝒳₁ⁿ[m])
		(θ₁, θ₂, θₘ) = (p[a₁], p[a₂], p[aₘ])
		
		output = ["Joint distribution:\n   ",
				  "$θ₁, $x₁ⁿ = $(f(a₁))\n   ",
				  "$θ₂, $x₁ⁿ = $(f(a₂))\n   ",
				  "...\n   ",
				  "$θₘ, $x₁ⁿ = $(f(aₘ))\n   "]
		
	end
	
	print(io, output...)
	
end

# ╔═╡ 70788e34-4423-11eb-3475-6f347ad28f99
md"""
> $$\large p(x_1^n;\pmb{\theta}(X_1^n)) = \begin{cases}
> \theta_1(X_1^n), & (x_1, \dots, x_n) = (\texttt{a}^{(1)}_1,\dots,\texttt{a}^{(n)}_1) \\
> \theta_2(X_1^n), & (x_1, \dots, x_n) = (\texttt{a}^{(1)}_2,\dots,\texttt{a}^{(n)}_1) \\
>  &\vdots \\
> \theta_{m_1\cdots m_n}(X_1^n), & (x_1, \dots, x_n) = (\texttt{a}^{(1)}_{m_1},\dots,\texttt{a}^{(n)}_{m_n}) 
> \end{cases}$$
> ### Joint distributions
"""

# ╔═╡ 7bee3d9e-43ed-11eb-2321-0142e52a67c6
q = Joint(
		Dict((:a₁⁽¹⁾, :a₁⁽²⁾, :a₁⁽³⁾, :a₁⁽ⁿ⁾) => :θ₁,
			 (:a₂⁽¹⁾, :a₁⁽²⁾, :a₁⁽³⁾, :a₁⁽ⁿ⁾) => :θ₂,
			 (:a₃⁽¹⁾, :a₁⁽²⁾, :a₁⁽³⁾, :a₁⁽ⁿ⁾) => :θ₃,
		# ...
			 (:aₘ⁽¹⁾, :aₘ⁽²⁾, :aₘ⁽³⁾, :aₘ⁽ⁿ⁾) => :θₘ)
	)

# ╔═╡ b793ece4-4425-11eb-0ca7-a1a947863cd9
md"""---"""

# ╔═╡ 5104fe72-4421-11eb-1c2d-eb6d265a57aa
mutable struct Partial <: Distribution 
	
	p::AbstractDict
	
	Partial(p::AbstractDict) = new(p)
	
	Partial() = new(Dict())
		
end

# ╔═╡ 40e134cc-4488-11eb-021c-1dc1a2f84192
mutable struct Conditional <: Distribution 
	
	p::AbstractDict
	
	Conditional(p::AbstractDict) = new(p)
	
	Conditional() = new(Dict())
		
end

# ╔═╡ 35a9f8fc-4484-11eb-3609-3f2109ee6f9a
function Base.show(io::IO, ::MIME"text/plain", p::Union{Partial,Conditional})
	
	𝒳𝒴 = sort(collect(keys(p))); (k, (n, m)) = (length(𝒳𝒴), length.(𝒳𝒴[1]))
	
	if n > 3 && m > 3
		
		x₁ⁿ = "(x₁, ..., xₙ)"; f = x₁ⁿ -> "($(x₁ⁿ[1]), ..., $(x₁ⁿ[n]))"
		y₁ᵐ = "(y₁, ..., yₘ)"; g = y₁ᵐ -> "($(y₁ᵐ[1]), ..., $(y₁ᵐ[m]))"
		
	elseif n > 3
		
		x₁ⁿ = "(x₁, ..., xₙ)"; f = x₁ⁿ -> "($(x₁ⁿ[1]), ..., $(x₁ⁿ[n]))"
		
		y₁ᵐ = m == 2 ? "(y₁, y₂)" : "(y₁, y₂, y₃)"
		g = m == 2 ? 
			y₁ᵐ -> "($(y₁ᵐ[1]), $(y₁ᵐ[m]))" : 
			y₁ᵐ -> "($(y₁ᵐ[1]), $(y₁ᵐ[2])), $(y₁ᵐ[m]))"
		
	elseif m > 3
		
		y₁ᵐ = "(y₁, ..., yₘ)"; g = y₁ᵐ -> "($(y₁ᵐ[1]), ..., $(y₁ᵐ[m]))"
		
		x₁ⁿ = n == 2 ? "(x₁, x₂)" : "(x₁, x₂, x₃)"
		f = n == 2 ? 
			x₁ⁿ -> "($(x₁ⁿ[1]), $(x₁ⁿ[m]))" : 
			x₁ⁿ -> "($(x₁ⁿ[1]), $(x₁ⁿ[2])), $(x₁ⁿ[m]))"
		
	end
		
	if n == m == 1
		
		if k <= 3
			
			output = [
				"Partial distribution:\n   ",
				["$θᵢ, x = $(aᵢ...) | y = $(bᵢ...)" for ((aᵢ, bᵢ), θᵢ) ∈ p]...
			]
			
		elseif k > 3
			
			((a₁, b₁), (a₂, b₂), (aₙ, bₘ)) = (𝒳𝒴[1], 𝒳𝒴[2], 𝒳𝒴[k])
			(θ₁, θ₂, θₙₘ) = (p[(a₁, b₁)], p[(a₂, b₂)], p[(aₙ, bₘ)])

			output = ["Partial distribution:\n   ",
					  "$θ₁, x = $(a₁...) | y = $(b₁...)\n   ",
					  "$θ₂, x = $(a₂...) | y = $(b₂...)\n   ",
					  "...\n   ",
					  "$θₙₘ, x = $(aₙ...) | y = $(bₘ...)\n   "]
			
		end
		
	elseif n > 1 && m > 1
		
		if k <= 3
			
			output = [
				"Partial distribution:\n   ",
				["$θᵢ, $x₁ⁿ = $(f(aᵢ)) | $y₁ᵐ = $(g(bᵢ))" for ((aᵢ, bᵢ), θᵢ) ∈ p]...
			]
			
		elseif k > 3
			
			((a₁, b₁), (a₂, b₂), (aₙ, bₘ)) = (𝒳𝒴[1], 𝒳𝒴[2], 𝒳𝒴[k])
			(θ₁, θ₂, θₙₘ) = (p[(a₁, b₁)], p[(a₂, b₂)], p[(aₙ, bₘ)])

			output = ["Partial distribution:\n   ",
					  "$θ₁, $x₁ⁿ = $(f(a₁)) | $y₁ᵐ = $(g(b₁))\n   ",
					  "$θ₂, $x₁ⁿ = $(f(a₂)) | $y₁ᵐ = $(g(b₂))\n   ",
					  "...\n   ",
					  "$θₙₘ, $x₁ⁿ = $(f(aₙ)) | $y₁ᵐ = $(g(bₘ))\n   "]
			
		end
		
	end
	
	print(io, output...)
		 
end

# ╔═╡ 8fecb602-4424-11eb-0c5c-1d41914a16e6
md"""
> $$\large p(x | y;\pmb{\theta}(X|Y)) = \begin{cases}
> \theta_1(X|Y), & x = a_1 | y = b_1 \\
> \theta_2(X|Y), & x = a_2 | y = b_1 \\
>  &\vdots \\
> \theta_{nm}(X|Y), & x = a_n | y = b_m \end{cases}$$
> ### Partial, Conditional distributions
> ---
"""

# ╔═╡ 0eada20a-43f3-11eb-2c9c-6f426a82c1d8
r = Partial(		
		Dict(((:a₁,), (:b₁,)) => :θ₁,
			 ((:a₂,), (:b₁,)) => :θ₂,
			 ((:a₃,), (:b₁,)) => :θ₃,
		# ...
			 ((:aₙ,), (:bₘ,)) => :θₙₘ)
	)

# ╔═╡ Cell order:
# ╠═2e43cbb6-4421-11eb-300a-75a8960cba3d
# ╟─0662de9c-4489-11eb-2c09-3fbbe5767dbb
# ╟─7530335e-441a-11eb-1c57-27bb1dcecabc
# ╟─eb17f3cc-4488-11eb-0561-6b8c64ed0660
# ╟─192a9d4e-441d-11eb-18ac-1b2895e954f8
# ╠═3bd0c82e-441c-11eb-18a3-6b893e733f6a
# ╟─0af1b628-4480-11eb-2fd0-9941429c9de8
# ╟─b92053a2-4422-11eb-0ef7-c117d54e6ca5
# ╠═d30cb11a-43dd-11eb-299a-85f283d89cb2
# ╟─8f1f6bc6-4425-11eb-024c-c99a562ce2f6
# ╠═3bbaf440-4421-11eb-26dc-9b88f155f5c4
# ╟─abceaea0-4482-11eb-2462-0f3ce0c40ef9
# ╟─70788e34-4423-11eb-3475-6f347ad28f99
# ╠═7bee3d9e-43ed-11eb-2321-0142e52a67c6
# ╟─b793ece4-4425-11eb-0ca7-a1a947863cd9
# ╠═5104fe72-4421-11eb-1c2d-eb6d265a57aa
# ╠═40e134cc-4488-11eb-021c-1dc1a2f84192
# ╟─35a9f8fc-4484-11eb-3609-3f2109ee6f9a
# ╟─8fecb602-4424-11eb-0c5c-1d41914a16e6
# ╠═0eada20a-43f3-11eb-2c9c-6f426a82c1d8
