using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.Models
{
    public class Config
    {
        [PrimaryKey]
        public string Name { get; set; }
        public string Value { get; set; }
        public int IsEnabled { get; set; }
    }
}
