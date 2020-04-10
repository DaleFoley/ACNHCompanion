using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace ACNHGuide.Models
{
    public class Critter
    {
        public string Name { get; set; }
        public string SellIcon { get; set; }
        public long SellPrice { get; set; }
        public string Location { get; set; }
        public string Icon { get; set; }
        public string Time { get; set; }
        //TODO: Season object
    }
}
