using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using ACNHCompanion.Models;
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

        public List<Config> GetConfigValues()
        {
            return _dbConnection.Query<Config>("select * from [config]");
        }

        public void UpdateConfigValue(Config configToUpdate)
        {
            int rowsUpdated = _dbConnection.Update(configToUpdate);
            if (rowsUpdated == 0)
            {
                //Row didn't update, now what?
            }
        }

        public List<CritterMonths> GetFishNorthern()
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_fish_northern]");
        }

        public List<CritterMonths> GetFishSouthern()
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_fish_southern]");
        }

        public List<CritterMonths> GetBugsSouthern()
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_bugs_southern]");
        }

        public List<CritterMonths> GetBugsNorthern()
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_bugs_northern]");
        }

        public void UpdateCritterIsDonated(Critters critterToUpdate)
        {
            //Doing nothing with this variable.
            int rowsUpdated = _dbConnection.Update(critterToUpdate);
            if(rowsUpdated == 0)
            {
                //Row didn't update, now what?
            }
        }
    }
}
