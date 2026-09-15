defmodule GungeonSearchWeb.GunLive.Show do
  use GungeonSearchWeb, :live_view

  alias GungeonSearch.Catalog

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    gun = Catalog.get_gun!(id)
    {:ok, assign(socket, gun: gun, synergies: Catalog.synergies_for(gun), page_title: gun.name)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.link navigate={~p"/"} class="text-sm text-amber-400 hover:text-amber-300">
        &larr; back to search
      </.link>

      <h1 class="mt-2 text-2xl font-bold">{@gun.name}</h1>
      <p :if={@gun.quote} class="italic text-stone-400">{@gun.quote}</p>

      <div class="mt-4 grid gap-6 sm:grid-cols-[auto_1fr]">
        <img :if={@gun.image} src={@gun.image} class="h-32 w-32 object-contain" />

        <dl class="grid grid-cols-2 gap-x-4 gap-y-1 text-sm">
          <.stat label="Type" value={@gun.type} />
          <.stat label="Quality" value={@gun.quality} />
          <.stat label="Damage" value={@gun.damage} />
          <.stat label="Fire Rate" value={@gun.fire_rate} />
          <.stat label="Magazine Size" value={@gun.magazine_size} />
          <.stat label="Ammo Capacity" value={@gun.ammo_capacity} />
          <.stat label="Reload Time" value={@gun.reload_time} />
          <.stat label="Shot Speed" value={@gun.shot_speed} />
          <.stat label="Spread" value={@gun.spread} />
        </dl>
      </div>

      <p :if={@gun.notes} class="mt-4 text-stone-300">{@gun.notes}</p>

      <div :if={@synergies != []} class="mt-8">
        <h2 class="text-lg font-semibold">Synergies</h2>
        <ul class="mt-2 space-y-3">
          <li :for={synergy <- @synergies}>
            <p class="font-medium text-amber-400">{synergy.name}</p>
            <p class="text-sm text-stone-300">{synergy.effect}</p>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  defp stat(assigns) do
    ~H"""
    <div :if={@value} class="contents">
      <dt class="text-stone-500">{@label}</dt>
      <dd>{@value}</dd>
    </div>
    """
  end
end
