defmodule Tasktracker.Repo.Migrations.EditTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
    remove :time_spent
end
  end
end
