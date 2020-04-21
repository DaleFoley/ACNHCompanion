using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.IO;
using ACNHCompanion.Models;
using SQLite;
using Xamarin.Forms;
using System.Linq;

namespace ACNHCompanion
{
    public class Database
    {
        SQLiteConnection _dbConnection;
        public Database()
        {
            _dbConnection = DependencyService.Get<IDBInterface>().CreateConnection();
        }

        public void ApplySchemaChangesBasedOnAppVersion()
        {
            string pathSQLDDL = "SQL/DDL";

            string pathPersonalFolder = Environment.GetFolderPath(Environment.SpecialFolder.Personal);
            IEnumerable<string> sqlFilesToApply = Directory.GetFiles(Path.Combine(pathPersonalFolder, pathSQLDDL), "*.sql");

            Config configVersionParameter = GetConfigValues("version").FirstOrDefault();
            if (configVersionParameter is null)
            {
                return;
            }

            int configVersionValue = int.Parse(configVersionParameter.Value);

            foreach (string sqlFileToApply in sqlFilesToApply)
            {
                int sqlFileVersion = int.Parse(Path.GetFileNameWithoutExtension(sqlFileToApply));
                if(configVersionValue < sqlFileVersion)
                {
                    string sqlContent = File.ReadAllText(sqlFileToApply);

                    SQLiteCommand sqLiteCommand = _dbConnection.CreateCommand(sqlContent);
                    sqLiteCommand.ExecuteNonQuery();

                    configVersionParameter.Value = sqlFileVersion.ToString();
                    UpdateConfigValue(configVersionParameter);
                }
            }
        }

        public List<Config> GetConfigValues()
        {
            return _dbConnection.Query<Config>("select * from [config]");
        }

        public List<Config> GetConfigValues(string name)
        {
            List<Config> configValues = _dbConnection.Query<Config>("select * from [config] where Name = ?", name);
            return configValues;
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
