using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.DBModels
{
    public class Critter
    {
        public string critter_name { get; set; }
        public int sell_price { get; set; }
        public string location { get; set; }
        public string time { get; set; }
        public string shadow_size { get; set; }
        public string type { get; set; }
        public string image_name { get; set; }
        public bool is_donated { get; set; }
        public string months { get; set; }
    }
}
