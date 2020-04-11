using System;
using System.Collections.Generic;
using System.Text;
using ACNHGuide.DBModels;
using SQLite;
using Xamarin.Forms;

namespace ACNHGuide
{
    public class DatabaseManager
    {
        SQLiteConnection _dbConnection;
        public DatabaseManager()
        {
            _dbConnection = DependencyService.Get<IDBInterface>().CreateConnection();
        }

        public List<Critter> GetAllCritters()
        {
            return _dbConnection.Query<Critter>("select * from [v_bugs_northern]");
        }
    }
}
