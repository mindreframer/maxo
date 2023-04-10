defmodule Maxo.Conf.MapValueTest do
  use ExUnit.Case

  alias Maxo.Conf.MapValue

  describe "MapValue.get" do
    test "get required value in plain key atom map" do
      scope = %{a: 1, b: 2, c: 3}
      assert 1 == MapValue.getr!(scope, "a")
      assert {:ok, 1} == MapValue.getr(scope, "a")
      assert {:ok, 1} == MapValue.getr(scope, "a", when: true)
      assert {:ok, nil} == MapValue.getr(scope, "a", when: false)
    end

    test "throw error when try get required value in plain key atom map" do
      scope = %{a: 1, b: 2, c: 3}
      assert {:error, :required} == MapValue.getr(scope, "d")

      assert_raise(RuntimeError, "Value of 'd' is required", fn ->
        MapValue.getr!(scope, "d")
      end)
    end

    test "get value in plain key atom map" do
      scope = %{a: 1, b: 2, c: 3}
      assert 1 == MapValue.get(scope, "a")
    end

    test "get value in plain key string map" do
      scope = %{"a" => 1, "b" => 2, "c" => 3}
      assert 1 == MapValue.get(scope, "a")
    end

    test "get value in deep key atom map" do
      scope = %{a: 1, b: 2, c: 3, d: %{a: 4}}
      assert 4 == MapValue.get(scope, "d.a")
    end

    test "get nil in deep key atom map when not exists field" do
      scope = %{a: 1, b: 2, c: 3, d: %{a: 4}}
      assert nil == MapValue.get(scope, "d.b")
    end

    test "get value in deep key string map" do
      scope = %{"a" => 1, "b" => 2, "c" => 3, "d" => %{"a" => 4}}
      assert 4 == MapValue.get(scope, "d.a")
    end

    test "get nil in deep key string map when not exists field" do
      scope = %{"a" => 1, "b" => 2, "c" => 3, "d" => %{"a" => 4}}
      assert nil == MapValue.get(scope, "d.b")
    end

    test "get value in deep key string or atom (mescled) map" do
      scope = %{"a" => 1, "b" => 2, "c" => 3, d: %{"a" => 4}}
      assert 4 == MapValue.get(scope, "d.a")
      scope = %{"a" => 1, "b" => 2, "c" => 3, d: %{"a" => 4, e: 7}}
      assert 7 == MapValue.get(scope, "d.e")
    end

    test "get values in deep key string map when field type atom or string" do
      scope = %{"a" => 1, "b" => [1, 2], "c" => 3, "d" => [%{"a" => 4}, %{a: 1, c: 1}]}
      assert [1, 2] == MapValue.get(scope, "b")
      assert [4, 1] == MapValue.get(scope, "d.a")
    end

    test "get optional fields values with null values" do
      scope = %{"a" => 5, "b" => ""}
      assert 5 == MapValue.get(scope, "e|b|a", null_values: [nil, ""])
    end

    test "get optional fields values" do
      scope = %{"a" => 1, "b" => [1, 2], "c" => 3, "d" => [%{"a" => 4}, %{a: 1, c: 1}]}
      assert [1, 2] == MapValue.get(scope, "b|a")
      assert 1 == MapValue.get(scope, "e|a")
      assert 1 == MapValue.get(scope, "e|f|a")
      assert 1 == MapValue.get(scope, "e|f|a", null_values: [nil, ""])
      assert 1 == MapValue.get(scope, "e|f|a", when: true)
      assert nil == MapValue.get(scope, "e|f|a", when: false)
    end

    test "get multiple fields values" do
      scope = %{"a" => 1, "b" => [1, 2], "c" => 3, "d" => [%{"a" => 4}, %{a: 1, c: 1}]}
      assert %{"a" => 1, "b" => [1, 2]} == MapValue.getm(scope, "b,a")
      assert %{"b" => [1, 2], "d.a" => [4, 1]} == MapValue.getm(scope, "b,d.a")
      assert %{"b" => [1, 2], "d.a" => [4, 1]} == MapValue.getm({:error, scope}, "b,d.a")

      assert %{"b" => [1, 2], "d.a" => [4, 1]} ==
               MapValue.getm({:error, scope}, "b,d.a", when: true)

      assert nil == MapValue.getm({:error, scope}, "b,d.a", when: false)
    end
  end

  describe "MapValue.insert" do
    test "insert value in map" do
      scope = %{a: 1, b: 2, c: 3}
      assert Map.merge(scope, %{"ab" => 1}) == MapValue.insert(scope, "ab", 1)
    end

    test "replace value in deep key atom map" do
      scope = %{a: 1, b: 2, c: 3, d: %{a: 4}}
      assert %{a: 1, b: 2, c: 3, d: %{a: 3}} == MapValue.insert(scope, "d.a", 3)

      scope = %{a: 1, b: 2, c: 3, d: %{"a" => 4}}
      assert %{a: 1, b: 2, c: 3, d: %{"a" => 3}} == MapValue.insert(scope, "d.a", 3)
    end

    test "insert value on every field in field list on map " do
      scope = %{"d" => [%{"a" => 4}, %{a: 2}]}
      assert %{"d" => [%{"a" => 1}, %{a: 1}]} == MapValue.insert(scope, "d[@].a", 1)
    end

    test "insert value on index field in field list on map " do
      scope = %{"d" => [%{"a" => 4}, %{a: 2}]}
      assert %{"d" => [%{"a" => 1}, %{a: 2}]} == MapValue.insert(scope, "d[0].a", 1)
    end

    test "insert new field value on index field in field list on map " do
      scope = %{"d" => [%{"a" => 4}, %{a: 2}]}
      assert %{"d" => [%{"a" => 4, "c" => 1}, %{a: 2}]} == MapValue.insert(scope, "d[0].c", 1)
    end

    test "insert new field value on all list" do
      scope = [%{"a" => 4}, %{a: 2}]
      assert [%{"a" => 4, "c" => 1}, %{"c" => 1, a: 2}] == MapValue.insert(scope, "_[*].c", 1)
    end

    test "deep insert" do
      map = %{
        "data" => [
          %{
            "name" => "Empresa de Tal",
            "key" => "fulano.tal@provedor.com.br",
            "inserted_at" => "2020-01-23T20:20:12.015Z",
            "updated_at" => "2020-01-23T20:20:12.015Z"
          },
          %{
            "key" => "+5511912345678",
            "name" => "Empresa de Tal",
            "inserted_at" => "2020-01-23T20:20:13.015Z",
            "updated_at" => "2020-01-23T20:20:13.015Z"
          }
        ],
        "date" => "2023-03-27T13:07:08.277451Z"
      }

      keys = %{
        "data.key" => "keys[@].key1",
        "data.inserted_at" => "keys[@].inserted_at1",
        "data.updated_at" => "keys[@].updated_at1",
        "data.name" => "keys[@].name1",
        "date" => "new_date"
      }

      value =
        keys
        |> Enum.reduce(%{}, fn {key, value}, acc ->
          v = MapValue.get(map, key)
          if is_nil(v), do: acc, else: MapValue.insert(acc, value, v)
        end)

      assert %{
               "new_date" => "2023-03-27T13:07:08.277451Z",
               "keys" => [
                 %{
                   "name1" => "Empresa de Tal",
                   "key1" => "fulano.tal@provedor.com.br",
                   "inserted_at1" => "2020-01-23T20:20:12.015Z",
                   "updated_at1" => "2020-01-23T20:20:12.015Z"
                 },
                 %{
                   "key1" => "+5511912345678",
                   "name1" => "Empresa de Tal",
                   "inserted_at1" => "2020-01-23T20:20:13.015Z",
                   "updated_at1" => "2020-01-23T20:20:13.015Z"
                 }
               ]
             } = value

      keys = %{
        "data.key" => "keys.key1",
        "data.inserted_at" => "keys.inserted_at1",
        "data.updated_at" => "keys.updated_at1",
        "data.name" => "keys.name1",
        "date" => "new_date"
      }

      value =
        keys
        |> Enum.reduce(%{}, fn {key, value}, acc ->
          v = MapValue.get(map, key)
          if is_nil(v), do: acc, else: MapValue.insert(acc, value, v)
        end)

      assert %{
               "new_date" => "2023-03-27T13:07:08.277451Z",
               "keys" => %{
                 "name1" => ["Empresa de Tal", "Empresa de Tal"],
                 "key1" => ["fulano.tal@provedor.com.br", "+5511912345678"],
                 "inserted_at1" => ["2020-01-23T20:20:12.015Z", "2020-01-23T20:20:13.015Z"],
                 "updated_at1" => ["2020-01-23T20:20:12.015Z", "2020-01-23T20:20:13.015Z"]
               }
             } = value
    end
  end
end
