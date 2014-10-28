defmodule Stat.Server do


	use ExActor.GenServer, export: :stat_server
	use Tinca, [:__stat_cache__]
	defmodule Unit do
		@derive [HashUtils]
		defstruct 	for_period: %{},
					full: %{}
	end


	def stat(id) do
		get([id])
	end
	def get(path) do
		Tinca.get(:state)
			|> HashUtils.get(path)
	end
	def get_state do
		Tinca.get(:state)
	end

	definit do
		{:ok, %{} |> Tinca.put(:state)}
	end
	defcall set_state(new_state), when: (is_map(new_state)) do
		Map.values(new_state)
			|> 	Enum.each(fn(some) ->
					case some do
						%Unit{} -> :ok
						some_else -> raise "Stat.Server : can't set stat, got wrong element #{inspect some_else}"
					end
				end)
		{:reply, new_state, new_state |> Tinca.put(:state) }
	end
	defcall delete(id), state: state do
		{
			:reply,
			:ok,
			HashUtils.delete(state, id) |> Tinca.put(:state)
		}
	end
	defcall new_period, state: state do
		{
			:reply, 
			:ok,
			HashUtils.modify_all(state, fn(unit) -> HashUtils.modify_all(unit, :for_period, fn(_) -> 0 end ) end )
				|> Tinca.put(:state)
		}
	end
	defcall add(map, id), when: (is_map(map)), state: state do
		{
			:reply,
			map,
			add_proc(map, id, state) |> Tinca.put(:state)
		}
	end

	defp add_proc(map, id, state) do
		case HashUtils.get(state, id) do
			nil -> HashUtils.add(state, id, %Unit{for_period: map, full: map})
			_ -> HashUtils.to_list(map)
					|> Enum.reduce(state, 
						fn({key, val}, state) -> 
							case HashUtils.get(state, [id, :full, key]) do
								nil -> HashUtils.add(state, [id, :full, key], val)
										|> HashUtils.add([id, :for_period, key], val)
								_ -> HashUtils.modify( state, [id, :full, key], &(&1+val) )
										|> HashUtils.modify( [id, :for_period, key], &(&1+val) )
							end
						end )
		end
	end

end