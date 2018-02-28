defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Accounts.User
  alias Tasktracker.Social.Task

  schema "users" do
    field :email, :string
    field :name, :string
    belongs_to :manager, User
    has_many :tasks, Tasktracker.Social.Task
    has_many :users, User, foreign_key: :manager_id
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :manager_id])
    |> validate_required([:email, :name])
  end
end
