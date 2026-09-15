defmodule GungeonSearchWeb.CoreComponents do
  @moduledoc """
  Small set of shared function components (currently just flash messages).
  """
  use Phoenix.Component

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={Phoenix.LiveView.JS.push("lv:clear-flash", value: %{key: @kind}) |> Phoenix.LiveView.JS.hide(to: "##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 z-50 w-80 rounded-lg p-3 text-sm shadow-lg ring-1",
        @kind == :info && "bg-stone-800 text-stone-100 ring-stone-700",
        @kind == :error && "bg-red-950 text-red-100 ring-red-900"
      ]}
      {@rest}
    >
      {msg}
    </div>
    """
  end

  @doc "Renders both the :info and :error flash groups for the current assigns."
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} flash={@flash} />
    <.flash kind={:error} flash={@flash} />
    """
  end
end
