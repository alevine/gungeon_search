defmodule GungeonSearchWeb.HomeLive do
  use GungeonSearchWeb, :live_view

  alias GungeonSearch.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: [])}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, assign(socket, query: query, results: Catalog.search(query))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-bold">Search the Gungeon</h1>
      <p class="mt-1 text-sm text-stone-400">Fuzzy search for Enter the Gungeon guns and items.</p>

      <form id="search-form" phx-change="search" class="mt-6">
        <input
          type="search"
          name="query"
          value={@query}
          placeholder="Search for a gun or item..."
          autocomplete="off"
          autofocus
          phx-debounce="500"
          class="w-full rounded-lg border border-stone-700 bg-stone-900 px-4 py-2 text-stone-100 placeholder:text-stone-500 focus:border-amber-500 focus:outline-none"
        />
      </form>

      <p :if={@query != "" and @results == []} class="mt-6 text-sm text-stone-500">
        No matches for "{@query}".
      </p>

      <ul :if={@results != []} class="mt-6 divide-y divide-stone-800 rounded-lg border border-stone-800">
        <li :for={result <- @results}>
          <.link
            navigate={result_path(result)}
            class="flex items-center gap-3 px-4 py-2 hover:bg-stone-900"
          >
            <img
              :if={result.image}
              src={result.image}
              class="h-8 w-8 shrink-0 object-contain"
              loading="lazy"
            />
            <span>{result.name}</span>
            <span class="ml-auto text-xs uppercase text-stone-500">{result.type}</span>
          </.link>
        </li>
      </ul>
    </div>
    """
  end

  defp result_path(%{type: "gun", id: id}), do: ~p"/gun/#{id}"
  defp result_path(%{type: "item", id: id}), do: ~p"/item/#{id}"
end
