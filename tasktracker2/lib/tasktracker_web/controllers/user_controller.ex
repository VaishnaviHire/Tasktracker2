defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  import Ecto.Query
  alias Tasktracker.Social
  alias Tasktracker.Social.Task
  alias Tasktracker.Repo
  alias TasktrackerWeb.Router
  alias TasktrackerWeb.SessionController
  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User
  alias TasktrackerWeb.TaskController
  
  def index(conn, _params) do
   user1 = conn.assigns[:current_user]
   
   if user1.name == "root" do
    users = Accounts.list_users()
   else
    users = Repo.all(from u in Accounts.User, where: u.manager_id == ^user1.id)
 
   end
    render(conn, "index.html", users: users)
   
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    all_users = Accounts.list_users |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, all_users: all_users)
  end

  def create(conn, %{"user" => user_params}) do
    all_users = Accounts.list_users |> Enum.map(&{&1.name, &1.id})
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, all_users: all_users)
    end
  end

  def show(conn, %{"id" => id}) do
   all_users = Accounts.list_users |> Enum.map(&{&1.name, &1.id})
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user, all_users: all_users)
  end

  def edit(conn, %{"id" => id}) do
    all_users = Accounts.list_users |> Enum.map(&{&1.name, &1.id})
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, all_users: all_users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    all_users = Accounts.list_users |> Enum.map(&{&1.name, &1.id})
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, all_users: all_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    num_of_tasks = Repo.all(TasktrackerWeb.TaskController.my_tasks(user)) 
                   |> Enum.count
    IO.inspect(num_of_tasks)
     underlings = Repo.all(from u in Accounts.User, where: u.manager_id == ^user.id) |> Enum.count


    {:ok, _user} =  if num_of_tasks > 0 do
                         conn
                        |> put_flash(:error, "Invalid Action! Assign the Incomplete tasks or mark them complete") 
                        |> redirect(to: user_path(conn, :index))
                    if underlings > 0 do 
   			conn
                        |> put_flash(:error, "Assign underlings to other managers")
                        |> redirect(to: user_path(conn, :index))

                        end
                    else
                        Accounts.delete_user(user)
                        conn
                        |> put_flash(:info, "User deleted successfully.")
                        |> redirect(to: user_path(conn, :index))
                  end
  end
end

