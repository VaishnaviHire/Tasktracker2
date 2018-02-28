defmodule Tasktracker.Time do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo
  alias Tasktracker.Accounts.User
  alias Tasktracker.Social.Task
  alias Tasktracker.Time.Blocks

  @doc """
  Returns the list of time_blocks.

  ## Examples

      iex> list_time_blocks()
      [%Blocks{}, ...]

  """
  def list_time_blocks do
    Repo.all(Blocks)
  end

  @doc """
  Gets a single blocks.

  Raises `Ecto.NoResultsError` if the Blocks does not exist.

  ## Examples

      iex> get_blocks!(123)
      %Blocks{}

      iex> get_blocks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_blocks!(id), do: Repo.get!(Blocks, id)

  @doc """
  Creates a blocks.

  ## Examples

      iex> create_blocks(%{field: value})
      {:ok, %Blocks{}}

      iex> create_blocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blocks(attrs \\ %{}) do
    %Blocks{}
    |> Blocks.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blocks.

  ## Examples

      iex> update_blocks(blocks, %{field: new_value})
      {:ok, %Blocks{}}

      iex> update_blocks(blocks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blocks(%Blocks{} = blocks, attrs) do
    blocks
    |> Blocks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Blocks.

  ## Examples

      iex> delete_blocks(blocks)
      {:ok, %Blocks{}}

      iex> delete_blocks(blocks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blocks(%Blocks{} = blocks) do
    Repo.delete(blocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blocks changes.

  ## Examples

      iex> change_blocks(blocks)
      %Ecto.Changeset{source: %Blocks{}}

  """
  def change_blocks(%Blocks{} = blocks) do
    Blocks.changeset(blocks, %{})
  end
  

def eachTaskBlock(task_id)do
 Repo.all(from t in Blocks, where: t.task_id == ^task_id, select: %{"id" => t.id, "start_time" => t.start_time, "end_time" => t.end_time})

end

  def time_map(user_id) do
    
Repo.all(from t in Blocks, where: is_nil(t.end_time),
 select: %{"id" => t.id , 
	  "start_time" => max(t.start_time), 
	"user_id" => t.user_id, 
	"task_id" => t.task_id, 
	"end_time" => t.end_time})

 end

 def taskEndTime(timemap)do
 
Repo.all(from t in Blocks, where: t.task_id == ^timemap["task_id"])
end


end
