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
            _dbConnection.Update(configToUpdate);
        }

        public List<CritterMonths> GetFishNorthern(string filterString = null)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_fish_northern] where 1=1 " + filterString);
        }

        public List<CritterMonths> GetFishSouthern(string filterString = null)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_fish_southern] where 1=1 " + filterString);
        }

        public List<CritterMonths> GetBugsSouthern(string filterString = null)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_bugs_southern] where 1=1 " + filterString);
        }

        public List<CritterMonths> GetBugsNorthern(string filterString = null)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_bugs_northern] where 1=1 " + filterString);
        }

        public void UpdateCritter(Critters critterToUpdate)
        {
            _dbConnection.Update(critterToUpdate);
        }
    }
}
