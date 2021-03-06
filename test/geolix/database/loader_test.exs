defmodule Geolix.Database.LoaderTest do
  use ExUnit.Case, async: true

  alias Geolix.Adapter.MMDB2
  alias Geolix.Database.Loader
  alias Geolix.Result


  @fixture_path [ __DIR__, "../../fixtures" ] |> Path.join() |> Path.expand()

  test "fetching registered database information" do
    id       = :fixture_city
    database = GenServer.call(Loader, { :get_database, id })

    assert %{ id: ^id } = database
  end

  test "fetching un-registered database information" do
    refute GenServer.call(Loader, { :get_database, :database_not_loaded })
  end


  test "error if database contains no metadata" do
    path = Path.join([ @fixture_path, ".gitignore" ])
    db   = %{ id: :invalid, adapter: MMDB2, source: path }

    assert { :error, :no_metadata } == Geolix.load_database(db)
  end

  test "reloading a database" do
    path_city    = Path.join([ @fixture_path, "GeoIP2-City-Test.mmdb" ])
    path_country = Path.join([ @fixture_path, "GeoIP2-Country-Test.mmdb" ])

    db_city    = %{ id: :reload, adapter: MMDB2, source: path_city }
    db_country = %{ id: :reload, adapter: MMDB2, source: path_country }

    assert :ok = Geolix.load_database(db_city)
    assert %Result.City{} = Geolix.lookup("2.125.160.216", where: :reload)

    assert :ok = Geolix.load_database(db_country)
    assert %Result.Country{} = Geolix.lookup("2.125.160.216", where: :reload)
  end

  test "system environment configuration" do
    path = Path.join([ @fixture_path, "GeoIP2-City-Test.mmdb" ])
    var  = "GEOLIX_TEST_DATABASE_PATH"
    db   = %{ id: :system_env, adapter: MMDB2, source: { :system, var }}

    System.put_env(var, path)

    assert :ok = Geolix.load_database(db)
    assert %Result.City{} = Geolix.lookup("2.125.160.216", where: :system_env)

    System.delete_env(var)
  end

  test "remote database" do
    # setup internal testing webserver
    Application.ensure_all_started(:inets)

    httpd_opts         = [ port:          0,
                           server_name:   'geolix_test',
                           server_root:   @fixture_path |> to_char_list,
                           document_root: @fixture_path |> to_char_list ]
    { :ok, httpd_pid } = :inets.start(:httpd, httpd_opts)

    # test remote file loading
    port = :httpd.info(httpd_pid)[:port]
    path = "http://localhost:#{ port }/GeoIP2-City-Test.mmdb"
    db   = %{ id: :remote, adapter: MMDB2, source: path }

    assert :ok = Geolix.load_database(db)
    assert %Result.City{} = Geolix.lookup("2.125.160.216", where: :remote)
  end


  test "database with invalid filename (not found)" do
    db = %{ id: :unknown_database, adapter: MMDB2, source: "invalid" }

    assert { :error, _ } = Geolix.load_database(db)
  end

  test "database with invalid filename (remote not found)" do
    db = %{ id: :unknown_database, adapter: MMDB2, source: "http://does.not.exist/" }

    assert { :error, _ } = Geolix.load_database(db)
  end
end
