using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using ACNHCompanion.DBModels;
using SQLite;
using Xamarin.Forms;

namespace ACNHCompanion
{
    public class DatabaseManager
    {
        SQLiteConnection _dbConnection;
        public DatabaseManager()
        {
            _dbConnection = DependencyService.Get<IDBInterface>().CreateConnection();
        }

        public List<CritterMonth> GetFishNorthern()
        {
            return _dbConnection.Query<CritterMonth>("select * from [v_fish_northern]");
        }

        public List<CritterMonth> GetFishSouthern()
        {
            return _dbConnection.Query<CritterMonth>("select * from [v_fish_southern]");
        }

        public List<CritterMonth> GetBugsSouthern()
        {
            return _dbConnection.Query<CritterMonth>("select * from [v_bugs_southern]");
        }

        public List<CritterMonth> GetBugsNorthern()
        {
            return _dbConnection.Query<CritterMonth>("select * from [v_bugs_northern]");
        }

        public void UpdateCritterIsDonated(Critters critterToUpdate)
        {
            //Doing nothing with this variable.
            int i = _dbConnection.Update(critterToUpdate);
        }
    }
}
