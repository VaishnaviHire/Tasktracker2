defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller
  use Ecto.Schema
  import Ecto.Query
  alias Tasktracker.Social
  alias Tasktracker.Social.Task
  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User
  alias Tasktracker.Repo
  alias TasktrackerWeb.Router
  alias TasktrackerWeb.SessionController  
  alias Tasktracker.Time
  alias Tasktracker.Time.Blocks
 
 def index(conn, _params) do
 

   user1 = conn.assigns[:current_user]
   complete_tasks = my_tasks(user1) |> complete |> Repo.all
   incomplete_tasks = my_tasks(user1) |> incomplete |> Repo.all
   under_all_tasks = underling_tasks(user1) |> Repo.all 
  
   tasks  =  Time.time_map(user1.id)
    
   block_info = Enum.map(tasks, fn(x) -> Time.taskEndTime(x) end) 
              |> List.flatten |> Enum.reduce(%{}, fn(x, values) -> Map.put(values,x["task_id"], x["id"]) end) |> IO.inspect


   if user1.name == "root" do
    render(conn, "root_index.html", complete_tasks: complete_tasks, incomplete_tasks: incomplete_tasks, block_info: block_info)
  else
 render(conn, "index.html", complete_tasks: complete_tasks, incomplete_tasks: incomplete_tasks, under_incomp_tasks: under_all_tasks,
   block_info: time_info)
end
  end

  def new(conn, _params) do

    user1 = conn.assigns[:current_user]     
    changeset = conn.assigns[:current_user] |> Ecto.build_assoc(:tasks, %Task{}) |> Task.changeset(_params)
    user_list = Repo.all(from u in Accounts.User, 
where: u.manager_id == ^user1.id)
	        |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, user_list: user_list)
  end

  def create(conn, %{"task" => task_params}) do
       
       user1 = conn.assigns[:current_user]
      changeset = conn.assigns[:current_user] |> Ecto.build_assoc(:tasks, %Task{})
               |> Task.changeset(task_params)

    user_list = Repo.all(from u in Accounts.User,
where: u.manager_id == ^user1.id) |> Enum.map(&{&1.name, &1.id})
    case Social.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, user_list: user_list)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Social.get_task!(id)
     user1 = conn.assigns[:current_user]
    user_list = Repo.all(from u in Accounts.User,
where: u.manager_id == ^user1.id) |> Enum.map(&{&1.name, &1.id})
    timeblocks = Time.eachTaskBlock(task.id)
                                  
    render(conn, "show.html", task: task, user_list: user_list, timeblocks: timeblocks)
  end

  def edit(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    user1 = conn.assigns[:current_user]
    user_list = Repo.all(from u in Accounts.User,
where: u.manager_id == ^user1.id) |> Enum.map(&{&1.name, &1.id})
    changeset  = Social.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset, user_list: user_list)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Social.get_task!(id)
     user1 = conn.assigns[:current_user]
    user_list = Repo.all(from u in Accounts.User,
where: u.manager_id == ^user1.id) |> Enum.map(&{&1.name, &1.id})
    case Social.update_task(task, task_params) do
      
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset, user_list: user_list)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    {:ok, _task} = Social.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

 def my_tasks(user) do
  if user.name == "root" do
    from t in Tasktracker.Social.Task

  else   
   Ecto.assoc(user, :tasks)
   end
end


def underling_tasks(user) do
   from t in Tasktracker.Social.Task, 
    join: u in Tasktracker.Accounts.User, on: t.user_id == u.id,
    where: u.manager_id == ^user.id 
   
end
 

 def status_task(conn, %{"id" => id}) do
   changeset = Repo.get!(Task, id)
   changeset = Ecto.Changeset.change changeset, status: true
   
  case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task completed successfully.")
        |> redirect(to: task_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Oops! Something went wrong")
        |> redirect(to: task_path(conn, :index))

    end


end


defp incomplete(usr_tasks) do
  from t in usr_tasks, where: t.status == false
end

defp complete(usr_tasks) do
  from t in usr_tasks, where: t.status == true
end
end
