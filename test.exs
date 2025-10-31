# Minimal Elixir test for libUnitConversion.so using pure Elixir FFI
# Run with: elixir test.exs

defmodule UnitConversion do
  @on_load :init

  def init do
    path = Path.join([File.cwd!(), "zig-out", "lib", "libUnitConversion"])
    :erlang.load_nif(String.to_charlist(path), 0)
  end

  def m_to_km(_meters), do: :erlang.nif_error(:not_loaded)
end

IO.puts("Testing m_to_km(1234) = 1.234")

result = UnitConversion.m_to_km(1234.0)
IO.puts("Result: #{result}")

if abs(result - 1.234) < 0.0001 do
  IO.puts("✓ TEST PASSED")
else
  IO.puts("✗ TEST FAILED")
end
