DROP INDEX IF EXISTS books_id_idx;
DROP INDEX IF EXISTS books_title_idx;
CREATE INDEX books_id_idx ON books (id);
CREATE INDEX books_title_idx ON books (title);
