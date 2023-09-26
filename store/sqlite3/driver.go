package sqlite3

import (
	"database/sql"

	"github.com/usememos/memos/store"
)

type Driver struct {
	db *sql.DB
}

func New(db *sql.DB) store.Driver {
	return &Driver{db: db}
}
