defmodule NflRushing.Data.ExporterTest do
  use NflRushing.DataCase

  alias NflRushing.Data.Exporter

  describe "run/2" do
    test "returns a csv binary with its contents and a list of headers" do
      contents = %{a: Faker.Pizza.cheese(), b: Faker.Pizza.meat(), c: Faker.Pizza.sauce()}
      assert Exporter.run([contents]) == "a,b,c\n#{contents.a},#{contents.b},#{contents.c}"
    end

    test "escapes commas when procesing fields" do
      first_content = Faker.Pizza.cheese()
      second_content = Faker.Pizza.cheese()
      contents = %{"a,b": "#{first_content},#{second_content}"}

      assert Exporter.run([contents]) == "a\\,b\n#{first_content}\\,#{second_content}"
    end

    test "uses processing functions on fields" do
      contents = %{a: 1}
      processing_function = fn element -> %{b: element.a} end

      assert Exporter.run([contents], processing_function) == "b\n#{contents.a}"
    end
  end
end
