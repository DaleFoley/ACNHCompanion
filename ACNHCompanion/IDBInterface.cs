using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion
{
    public interface IDBInterface
    {
        SQLiteConnection CreateConnection();
    }
}
