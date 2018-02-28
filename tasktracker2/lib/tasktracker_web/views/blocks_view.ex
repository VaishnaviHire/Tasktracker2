defmodule TasktrackerWeb.BlocksView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.BlocksView

  def render("index.json", %{time_blocks: time_blocks}) do
    %{data: render_many(time_blocks, BlocksView, "blocks.json")}
  end

  def render("show.json", %{blocks: blocks}) do
    %{data: render_one(blocks, BlocksView, "blocks.json")}
  end

  def render("blocks.json", %{blocks: blocks}) do
    %{id: blocks.id,
      start_time: blocks.start_time,
      end_time: blocks.end_time}
  end
end
