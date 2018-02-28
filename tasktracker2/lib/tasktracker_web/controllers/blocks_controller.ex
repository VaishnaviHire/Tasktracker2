defmodule TasktrackerWeb.BlocksController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Time
  alias Tasktracker.Time.Blocks

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    time_blocks = Time.list_time_blocks()
    render(conn, "index.json", time_blocks: time_blocks)
  end

  def create(conn, %{"blocks" => blocks_params}) do
    with {:ok, %Blocks{} = blocks} <- Time.create_blocks(blocks_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", blocks_path(conn, :show, blocks))
      |> render("show.json", blocks: blocks)
    end
  end

  def show(conn, %{"id" => id}) do
    blocks = Time.get_blocks!(id)
    render(conn, "show.json", blocks: blocks)
  end

  def update(conn, %{"id" => id, "blocks" => blocks_params}) do
    blocks = Time.get_blocks!(id)

    with {:ok, %Blocks{} = blocks} <- Time.update_blocks(blocks, blocks_params) do
      render(conn, "show.json", blocks: blocks)
    end
  end

  def delete(conn, %{"id" => id}) do
    blocks = Time.get_blocks!(id)
    with {:ok, %Blocks{}} <- Time.delete_blocks(blocks) do
      send_resp(conn, :no_content, "")
    end
  end
end
