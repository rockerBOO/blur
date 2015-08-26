defmodule Blur.Extension.Points do
  def start_link(opts, process_opts \\ []) do
    GenServer.start_link(__MODULE__, opts, process_opts)
  end

  def init([]) do
    {:ok, []}
  end

  def update_points() do
    Blur.Channel.users("#rockerboo")
    |> Enum.each(fn (user) ->
      result = Blur.Ext.Point.read!(user: user)

      IO.inspect result

      # %Blur.Ext.Point{user: user, points: result.points+15}
      # |> Blur.Ext.Point.write!
    end)
  end

  def handle_cast(:update_points, _from, state) do
    update_points()

    # ttl = 1000 * 60 * 15
    ttl = 15000

    :erlang.send_after(ttl, self, :update_points, [])

    {:noreply, state}
  end
end