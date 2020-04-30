using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.Models
{
    public class Event
    {
        [PrimaryKey, AutoIncrement]
        public int ID { get; set; }
        public string Name { get; set; }
        public int Month { get; set; }
        public int Day { get; set; }
        public bool IsIntervalBased { get; set; }
        public string Hemisphere { get; set; }
    }
}
