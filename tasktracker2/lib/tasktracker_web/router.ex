defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  def get_current_user(conn, params) do
    user_id = get_session(conn, :user_id)
    if user_id do
       user = Tasktracker.Accounts.get_user!(user_id)
       assign(conn, :current_user, user)
    else
     assign(conn, :current_user, nil)
    end
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    get "/test", PageController, :test
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    resources "/tasks", TaskController
    get "/tasks/:id/status_task", TaskController, :status_task
    put "tasks/:id/status_task", TaskController, :status_task

  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TasktrackerWeb do
    pipe_through :api
    resources "/time_blocks", BlocksController, except: [:new, :edit]

  end
end
