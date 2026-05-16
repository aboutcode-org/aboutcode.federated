Changelog
=============

v1.0.3 (May 15, 2026)
---------------------------

- Change build backend from ``setuptools`` to ``flot``. Properly construct wheel
  to include source files.

v1.0.2 (May 14, 2026)
---------------------------

- Bump ``requests`` dependency version to 2.33.1

v1.0.0 (May 12, 2026)
---------------------------

- Add new DataKind for ``api_package_metadata`` and
  ``api_package_version_response``. Add field ``datafile_name``  to DataCluster
  and modify ``datafile_path_template`` to use ``datafile_name`` instead of
  specifying the file name in ``datafile_path_template``.

v0.1.0 (October 20, 2025)
---------------------------

- Initial release of the ``aboutcode.federated`` library based on
  original work in the ``aboutcode.hashid`` library.
