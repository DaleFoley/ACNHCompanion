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
            string pathSQLDDL = "SQL";

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
                int sqlFileVersion;

                bool isSqlFileNameValid = int.TryParse(Path.GetFileNameWithoutExtension(sqlFileToApply), out sqlFileVersion);
                if (!isSqlFileNameValid) { continue; }

                if(configVersionValue < sqlFileVersion)
                {
                    string sqlContent = File.ReadAllText(sqlFileToApply);
                    string[] sqlContentLines = sqlContent.Split(";".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);

                    foreach (string sqlCommand in sqlContentLines)
                    {
                        string sqlCommandToExecute = sqlCommand.TrimStart('\r', '\n');
                        if(string.IsNullOrEmpty(sqlCommandToExecute)) { continue; }

                        _dbConnection.Execute(sqlCommandToExecute);
                    }

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

        public void InsertConfigValue(Config configToInsert)
        {
            _dbConnection.Insert(configToInsert);
        }

        public void UpdateConfigValue(Config configToUpdate)
        {
            _dbConnection.Update(configToUpdate);
        }

        public void InsertOrReplaceConfigValue(Config configToInsertOrReplace)
        {
            _dbConnection.InsertOrReplace(configToInsertOrReplace);
        }

        public List<SpeciesDistinct> GetDistinctSpecies()
        {
            return _dbConnection.Query<SpeciesDistinct>("select distinct Species, IconName, " +
                "(select count(v.ID) from villagers as v where v.Species = villagers.Species) as VillagerSpeciesCount " +
                "from villagers group by Species");
        }

        public List<Villagers> GetVillagers(string filterString = "")
        {
            return _dbConnection.Query<Villagers>("select * from [villagers] where 1=1 " + filterString);
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

        public void UpdatedVillagerIsResident(int ID, int isResident)
        {
            SQLiteCommand sqLiteCommand = _dbConnection.CreateCommand("update [villagers] set isResident = ? where ID = ?", isResident, ID);
            sqLiteCommand.ExecuteNonQuery();
        }

        public void UpdateCritterIsSculpted(int ID, bool isSculpted)
        {
            SQLiteCommand sqLiteCommand = _dbConnection.CreateCommand("update [critters] set IsSculpted = ? where ID = ?", isSculpted, ID);
            sqLiteCommand.ExecuteNonQuery();
        }

        public void UpdateCritter(Critters critterToUpdate)
        {
            _dbConnection.Update(critterToUpdate);
        }
    }
}
