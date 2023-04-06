defmodule Veryapp.Web.StickLiveTest do
  use Veryapp.Web.ConnCase

  import Phoenix.LiveViewTest
  import Veryapp.DemoFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_stick(_) do
    stick = stick_fixture()
    %{stick: stick}
  end

  describe "Index" do
    setup [:create_stick]

    test "lists all sticks", %{conn: conn, stick: stick} do
      {:ok, _index_live, html} = live(conn, index_path())

      assert html =~ "Listing Sticks"
      assert html =~ stick.name
    end

    test "saves new stick", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, index_path())

      assert index_live |> link_index_new() |> render_click() =~
               "New Stick"

      assert_patch(index_live, new_path())

      assert index_live
             |> fill_form(stick: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> fill_form(stick: @create_attrs)
             |> render_submit()

      assert_patch(index_live, index_path())

      html = render(index_live)
      assert html =~ "Stick created successfully"
      assert html =~ "some name"
    end

    test "updates stick in listing", %{conn: conn, stick: stick} do
      {:ok, index_live, _html} = live(conn, index_path())

      assert index_live |> link_index_edit(stick) |> render_click() =~
               "Edit Stick"

      assert_patch(index_live, index_edit_path(stick))

      assert index_live
             |> fill_form(stick: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> fill_form(stick: @update_attrs)
             |> render_submit()

      assert_patch(index_live, index_path())

      html = render(index_live)
      assert html =~ "Stick updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes stick in listing", %{conn: conn, stick: stick} do
      {:ok, index_live, _html} = live(conn, index_path())

      assert index_live |> link_index_delete(stick) |> render_click()
      refute has_element?(index_live, "#sticks-#{stick.id}")
    end
  end

  describe "Show" do
    setup [:create_stick]

    test "displays stick", %{conn: conn, stick: stick} do
      {:ok, _show_live, html} = live(conn, show_path(stick))

      assert html =~ "Show Stick"
      assert html =~ stick.name
    end

    test "updates stick within modal", %{conn: conn, stick: stick} do
      {:ok, show_live, _html} = live(conn, show_path(stick))

      assert show_live |> link_modal_edit() |> render_click() =~
               "Edit Stick"

      assert_patch(show_live, show_edit_path(stick))

      assert show_live
             |> fill_form(stick: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> fill_form(stick: @update_attrs)
             |> render_submit()

      assert_patch(show_live, show_path(stick))

      html = render(show_live)
      assert html =~ "Stick updated successfully"
      assert html =~ "some updated name"
    end

    # URL utils
    defp index_path, do: ~p"/sticks"
    defp new_path, do: ~p"/sticks/new"
    defp index_edit_path(stick), do: ~p"/sticks/#{stick}/edit"
    defp show_path(stick), do: ~p"/sticks/#{stick}"
    defp show_edit_path(stick), do: ~p"/sticks/#{stick}/show/edit"

    # Form utils
    defp fill_form(live, data), do: form(live, "#stick-form", data)

    # Link utils
    defp link_index_new(live), do: element(live, "a", "New Stick")
    defp link_index_edit(live, stick), do: element(live, "#sticks-#{stick.id} a", "Edit")

    defp link_index_delete(live, stick),
      do: element(live, "#sticks-#{stick.id} a", "Delete")

    defp link_modal_edit(live), do: element(live, "a", "Edit")
  end
end
