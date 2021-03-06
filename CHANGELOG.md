# Changelog

## v0.11.0 (2016-12-28)

- Enhancements
    - All configured databases can be reloaded in the background
      using `Geolix.reload_databases/0`
    - Database configuration has been extended to support adapters
    - `Geolix.Adapter.Fake` is provided for a custom managed database with
      fixed/pre-defined responses
    - "GeoIP-Enterprise" databases return structs instead of plain maps
    - Lookups are done with a configurable timeout

- Deprecations
    - Configuring the applications databases using `{ :id, filename }` tuples
      (or `Keyword.t`) has been deprecated in favor of a list of database
      definition maps
    - `Geolix.set_database/2` has been deprecated in favor of the new
      `Geolix.load_database/1`

## v0.10.1 (2016-06-04)

- Enhancements
    - Lookup results are generated with `:en` as the default
      if no locale is passed

## v0.10.0 (2016-04-04)

- Enhancements
    - Databases are reloaded if a storage process gets restarted
    - Databases can be directly loaded from remote (http) locations if
      configured ([#10](https://github.com/mneudert/geolix/pull/10))
    - Paths can be configured by accessing the system environment
    - Storage processes are now supervised

- Bug fixes
    - Traits from the database are properly passed on in the result

## v0.9.0 (2015-11-16)

- Enhancements
    - Allows usage of "GeoIP2-Precision-ISP" databases
    - Lookups querying all registered databases are done concurrently

## v0.8.0 (2015-07-18)

- Enhancements
    - Allows direct usage of gzip'ed database files
    - `:locale` lookup option for easier access to translatable result values
    - Dependencies not used in production builds are marked as optional

- Bug fixes
    - `Float` values are rounded to 4 decimal digits
    - `Double` values are rounded to 8 decimal digits

## v0.7.0 (2015-02-16)

- Enhancements
    - Supports IPv4 lookups in IPv6 notation ("0:0:0:0:0:FFFF:xxxx:xxxx")
    - Supports IPv6 lookups

## v0.6.0 (2015-02-08)

- Initial Release
