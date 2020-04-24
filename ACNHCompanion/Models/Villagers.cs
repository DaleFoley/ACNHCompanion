using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.Models
{
    public class Villagers
    {
        [PrimaryKey, AutoIncrement]
        public int ID { get; set; }
        public string Name { get; set; }
        public string Personality { get; set; }
        public string Species { get; set; }
        public string Birthday { get; set; }
        public string CatchPhrase { get; set; }
        public string ImageName { get; set; }
        public string IconName { get; set; }
        public int IsResident { get; set; }
    }
}
