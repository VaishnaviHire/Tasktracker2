defmodule TasktrackerWeb.BlocksControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.Time
  alias Tasktracker.Time.Blocks

  @create_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{end_time: nil, start_time: nil}

  def fixture(:blocks) do
    {:ok, blocks} = Time.create_blocks(@create_attrs)
    blocks
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all time_blocks", %{conn: conn} do
      conn = get conn, blocks_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create blocks" do
    test "renders blocks when data is valid", %{conn: conn} do
      conn = post conn, blocks_path(conn, :create), blocks: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, blocks_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => ~N[2010-04-17 14:00:00.000000],
        "start_time" => ~N[2010-04-17 14:00:00.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, blocks_path(conn, :create), blocks: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update blocks" do
    setup [:create_blocks]

    test "renders blocks when data is valid", %{conn: conn, blocks: %Blocks{id: id} = blocks} do
      conn = put conn, blocks_path(conn, :update, blocks), blocks: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, blocks_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => ~N[2011-05-18 15:01:01.000000],
        "start_time" => ~N[2011-05-18 15:01:01.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn, blocks: blocks} do
      conn = put conn, blocks_path(conn, :update, blocks), blocks: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete blocks" do
    setup [:create_blocks]

    test "deletes chosen blocks", %{conn: conn, blocks: blocks} do
      conn = delete conn, blocks_path(conn, :delete, blocks)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, blocks_path(conn, :show, blocks)
      end
    end
  end

  defp create_blocks(_) do
    blocks = fixture(:blocks)
    {:ok, blocks: blocks}
  end
end
