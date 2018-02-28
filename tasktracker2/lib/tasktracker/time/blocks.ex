defmodule Tasktracker.Time.Blocks do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Time.Blocks
  alias Tasktracker.Social.Task
  alias TaskTracker.Accounts.User
  schema "time_blocks" do
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    belongs_to :task, TaskTracker.Social.Task, foreign_key: :task_id
    belongs_to :user1, TaskTracker.Accounts.User, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(%Blocks{} = blocks, attrs) do
    blocks
    |> cast(attrs, [:start_time, :end_time, :task_id, :user_id])
    |> validate_required([:task_id])

  end
end
