defmodule Tasktracker.Social.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Social.Task
  alias Tasktracker.Time.Blocks

  schema "tasks" do
    field :status, :boolean
    field :task_body, :string
    field :task_title, :string
    
    
    belongs_to :user, Tasktracker.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:task_title, :task_body, :status, :user_id])
    |> validate_required([:task_title, :task_body, :status, :user_id], message: "User needs underlings to create task.")
  end
end
