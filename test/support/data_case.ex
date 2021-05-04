defmodule Canvas.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Canvas.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Canvas.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Canvas.DataCase
      import Canvas.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Canvas.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Canvas.Repo, {:shared, self()})
    end

    :ok
  end
end
