using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.Models
{
    public class CritterMonths
    {
        public int ID { get; set; }
        public string CritterName { get; set; }
        public int SellPrice { get; set; }
        public string Location { get; set; }
        public string Time { get; set; }
        public string ShadowSize { get; set; }
        public string Type { get; set; }
        public string ImageName { get; set; }
        public bool IsDonated { get; set; }
        public bool IsSculpted { get; set; }
        public bool IsCaptured { get; set; }
        public string Months { get; set; }
        public string Rarity { get; set; }
        public bool IsCatchableBasedOnMonth { get; set; }
        public bool IsCatchableBasedOnTime { get; set; }

    }
}
