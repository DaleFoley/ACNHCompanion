using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHGuide
{
    public interface IDBInterface
    {
        SQLiteConnection CreateConnection();
    }
}
