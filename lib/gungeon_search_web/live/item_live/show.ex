defmodule GungeonSearchWeb.ItemLive.Show do
  use GungeonSearchWeb, :live_view

  alias GungeonSearch.Catalog

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    item = Catalog.get_item!(id)

    {:ok,
     assign(socket, item: item, synergies: Catalog.synergies_for(item), page_title: item.name)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.link navigate={~p"/"} class="text-sm text-amber-400 hover:text-amber-300">
        &larr; back to search
      </.link>

      <h1 class="mt-2 text-2xl font-bold">{@item.name}</h1>
      <p :if={@item.quote} class="italic text-stone-400">{@item.quote}</p>

      <div class="mt-4 grid gap-6 sm:grid-cols-[auto_1fr]">
        <img :if={@item.image} src={@item.image} class="h-32 w-32 object-contain" />

        <dl class="grid grid-cols-2 gap-x-4 gap-y-1 text-sm">
          <.stat label="Type" value={@item.type} />
          <.stat label="Quality" value={quality_text(@item.quality)} />
        </dl>
      </div>

      <p :if={@item.effect} class="mt-4 text-stone-300">{@item.effect}</p>

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

  defp quality_text(nil), do: nil
  defp quality_text([]), do: nil
  defp quality_text(quality), do: Enum.join(quality, ", ")
end
