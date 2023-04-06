defmodule Veryapp.Web.CategoryLiveTest do
  use Veryapp.Web.ConnCase

  import Phoenix.LiveViewTest
  import Veryapp.StoreFixtures

  @create_attrs %{name: "some name", parent_id: 42}
  @update_attrs %{name: "some updated name", parent_id: 43}
  @invalid_attrs %{name: nil, parent_id: nil}

  defp create_category(_) do
    category = category_fixture()
    %{category: category}
  end

  describe "Index" do
    setup [:create_category]

    test "lists all categories", %{conn: conn, category: category} do
      {:ok, _index_live, html} = live(conn, index_path())

      assert html =~ "Listing Categories"
      assert html =~ category.name
    end

    test "saves new category", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, index_path())

      assert index_live |> link_index_new() |> render_click() =~
               "New Category"

      assert_patch(index_live, new_path())

      assert index_live
             |> fill_form(category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> fill_form(category: @create_attrs)
             |> render_submit()

      assert_patch(index_live, index_path())

      html = render(index_live)
      assert html =~ "Category created successfully"
      assert html =~ "some name"
    end

    test "updates category in listing", %{conn: conn, category: category} do
      {:ok, index_live, _html} = live(conn, index_path())

      assert index_live |> link_index_edit(category) |> render_click() =~
               "Edit Category"

      assert_patch(index_live, index_edit_path(category))

      assert index_live
             |> fill_form(category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> fill_form(category: @update_attrs)
             |> render_submit()

      assert_patch(index_live, index_path())

      html = render(index_live)
      assert html =~ "Category updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes category in listing", %{conn: conn, category: category} do
      {:ok, index_live, _html} = live(conn, index_path())

      assert index_live |> link_index_delete(category) |> render_click()
      refute has_element?(index_live, "#categories-#{category.id}")
    end
  end

  describe "Show" do
    setup [:create_category]

    test "displays category", %{conn: conn, category: category} do
      {:ok, _show_live, html} = live(conn, show_path(category))

      assert html =~ "Show Category"
      assert html =~ category.name
    end

    test "updates category within modal", %{conn: conn, category: category} do
      {:ok, show_live, _html} = live(conn, show_path(category))

      assert show_live |> link_modal_edit() |> render_click() =~
               "Edit Category"

      assert_patch(show_live, show_edit_path(category))

      assert show_live
             |> fill_form(category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> fill_form(category: @update_attrs)
             |> render_submit()

      assert_patch(show_live, show_path(category))

      html = render(show_live)
      assert html =~ "Category updated successfully"
      assert html =~ "some updated name"
    end
  end

  # URL utils
  defp index_path, do: ~p"/categories"
  defp new_path, do: ~p"/categories/new"
  defp index_edit_path(category), do: ~p"/categories/#{category}/edit"
  defp show_path(category), do: ~p"/categories/#{category}"
  defp show_edit_path(category), do: ~p"/categories/#{category}/show/edit"

  # Form utils
  defp fill_form(live, data), do: form(live, "#category-form", data)

  # Link utils
  defp link_index_new(live), do: element(live, "a", "New Category")
  defp link_index_edit(live, category), do: element(live, "#categories-#{category.id} a", "Edit")

  defp link_index_delete(live, category),
    do: element(live, "#categories-#{category.id} a", "Delete")

  defp link_modal_edit(live), do: element(live, "a", "Edit")
end
