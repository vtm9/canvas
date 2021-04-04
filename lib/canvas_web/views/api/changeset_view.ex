defmodule CanvasWeb.Api.ChangesetView do
  use CanvasWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `BowlingWeb.ErrorHelpers.translate_error/1` for more details.
  """

  # FIXME: remove custom translate_errors function for PolymorphicEmbed
  # after this issue is fixed
  # https://github.com/mathieuprog/polymorphic_embed/issues/38
  def translate_errors(%{changes: %{props: %Ecto.Changeset{} = props_changes}} = changeset) do
    props_errors = Ecto.Changeset.traverse_errors(props_changes, &translate_error/1)
    errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    Map.merge(errors, %{props: props_errors})
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end
end
