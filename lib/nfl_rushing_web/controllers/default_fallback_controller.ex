defmodule NflRushingWeb.DefaultFallbackController do
  use NflRushingWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn

  def call(conn = %Conn{}, {:error, changeset = %Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NflRushingWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn = %Conn{}, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(NflRushingWeb.ErrorView)
    |> render(:"404")
  end
end
