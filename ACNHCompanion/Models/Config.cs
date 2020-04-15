using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.Models
{
    public class Config
    {
        [PrimaryKey, AutoIncrement]
        public int ID { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public int IsEnabled { get; set; }
    }
}
