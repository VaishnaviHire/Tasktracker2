defmodule Tasktracker.TimeTest do
  use Tasktracker.DataCase

  alias Tasktracker.Time

  describe "time_blocks" do
    alias Tasktracker.Time.Blocks

    @valid_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{end_time: nil, start_time: nil}

    def blocks_fixture(attrs \\ %{}) do
      {:ok, blocks} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Time.create_blocks()

      blocks
    end

    test "list_time_blocks/0 returns all time_blocks" do
      blocks = blocks_fixture()
      assert Time.list_time_blocks() == [blocks]
    end

    test "get_blocks!/1 returns the blocks with given id" do
      blocks = blocks_fixture()
      assert Time.get_blocks!(blocks.id) == blocks
    end

    test "create_blocks/1 with valid data creates a blocks" do
      assert {:ok, %Blocks{} = blocks} = Time.create_blocks(@valid_attrs)
      assert blocks.end_time == ~N[2010-04-17 14:00:00.000000]
      assert blocks.start_time == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_blocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_blocks(@invalid_attrs)
    end

    test "update_blocks/2 with valid data updates the blocks" do
      blocks = blocks_fixture()
      assert {:ok, blocks} = Time.update_blocks(blocks, @update_attrs)
      assert %Blocks{} = blocks
      assert blocks.end_time == ~N[2011-05-18 15:01:01.000000]
      assert blocks.start_time == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_blocks/2 with invalid data returns error changeset" do
      blocks = blocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_blocks(blocks, @invalid_attrs)
      assert blocks == Time.get_blocks!(blocks.id)
    end

    test "delete_blocks/1 deletes the blocks" do
      blocks = blocks_fixture()
      assert {:ok, %Blocks{}} = Time.delete_blocks(blocks)
      assert_raise Ecto.NoResultsError, fn -> Time.get_blocks!(blocks.id) end
    end

    test "change_blocks/1 returns a blocks changeset" do
      blocks = blocks_fixture()
      assert %Ecto.Changeset{} = Time.change_blocks(blocks)
    end
  end
end
