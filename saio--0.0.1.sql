/* contrib/saio/saio--0.0.1.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION saio" to load this file. \quit

-- The extension installs a join_search_hook from _PG_init() and exposes its
-- behavior via GUCs ("saio", "saio_seed", ...).  No SQL objects are created.
