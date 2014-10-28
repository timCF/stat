defmodule StatTest do
  use ExUnit.Case

  test "the truth" do
  	assert %{} == Stat.Server.get_state
  	assert nil == Stat.Server.get("test")
  	assert nil == Stat.Server.get(["test", :a])
    assert %{a: 1, b: 0} == Stat.Server.add(%{a: 1, b: 0}, "test")
    assert %Stat.Server.Unit{full: %{a: 1, b: 0}, for_period: %{a: 1, b: 0}} == Stat.Server.stat("test")
    assert %{"test" => %Stat.Server.Unit{full: %{a: 1, b: 0}, for_period: %{a: 1, b: 0}}} == Stat.Server.get_state
    assert :ok == Stat.Server.new_period
    assert %{"test" => %Stat.Server.Unit{full: %{a: 1, b: 0}, for_period: %{a: 0, b: 0}}} == Stat.Server.get_state
    assert %{a: 1, b: 0} == Stat.Server.add(%{a: 1, b: 0}, "test")
    assert %{"test" => %Stat.Server.Unit{full: %{a: 2, b: 0}, for_period: %{a: 1, b: 0}}} == Stat.Server.get_state
    assert %{a: 2, b: 0} == Stat.Server.get(["test", :full])
    assert 1 == Stat.Server.get(["test", :for_period, :a])
  end
end
