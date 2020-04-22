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
                configVersionParameter = new Config
                {
                    Name = "version",
                    Value = "100",
                    IsEnabled = 1
                };

                InsertConfigValue(configVersionParameter);
            }

            int configVersionValue = int.Parse(configVersionParameter.Value);

            foreach (string sqlFileToApply in sqlFilesToApply)
            {
                int sqlFileVersion = int.Parse(Path.GetFileNameWithoutExtension(sqlFileToApply));
                if(configVersionValue < sqlFileVersion)
                {
                    string sqlContent = File.ReadAllText(sqlFileToApply);
                    string[] sqlContentLines = sqlContent.Split(';');

                    foreach (string sqlCommand in sqlContentLines)
                    {
                        if (string.IsNullOrEmpty(sqlCommand)) { continue; }
                        int i = _dbConnection.Execute(sqlCommand);
                    }

                    configVersionParameter.Value = sqlFileVersion.ToString();
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

        public void InsertConfigValue(Config configToInsert)
        {
            _dbConnection.Insert(configToInsert);
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

        public List<CritterMonths> GetBugsNorthernSearch(string searchCriteria)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_bugs_northern] where CritterName like '" + searchCriteria + "%'");
        }

        public List<CritterMonths> GetBugsSouthernSearch(string searchCriteria)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_bugs_southern] where CritterName like '" + searchCriteria + "%'");
        }

        public List<CritterMonths> GetFishNorthernSearch(string searchCriteria)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_fish_northern] where CritterName like '" + searchCriteria + "%'");
        }

        public List<CritterMonths> GetFishSouthernSearch(string searchCriteria)
        {
            return _dbConnection.Query<CritterMonths>("select * from [v_fish_southern] where CritterName like '" + searchCriteria + "%'");
        }

        public void UpdateCritterIsDonated(int ID, bool isDonated)
        {
            SQLiteCommand sqLiteCommand = _dbConnection.CreateCommand("update [critters] set IsDonated = ? where ID = ?", isDonated, ID);
            sqLiteCommand.ExecuteNonQuery();
        }

        public void UpdateCritter(Critters critterToUpdate)
        {
            _dbConnection.Update(critterToUpdate);
        }
    }
}
