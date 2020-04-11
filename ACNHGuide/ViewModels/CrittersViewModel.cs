using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Xamarin.Forms;

using ACNHGuide.Models;
using ACNHGuide.Views;

namespace ACNHGuide.ViewModels
{
    class CrittersViewModel : BaseViewModel
    {
        public List<Critter> Critters { get; set; }
        public CrittersViewModel()
        {
            Title = "Critters";
            Critters = new List<Critter>();

            Critter TestCritterOne = new Critter
            {
                Name = "Common Butterfly",
                SellIcon = "BellCoin.png",
                SellPrice = 2000,
                Time = "4am - 7pm",
                Location = "Flying",
                Icon = "Common_butterfly.png"
            };

            Critter TestCritterTwo = new Critter
            {
                Name = "Common Butterfly",
                SellIcon = "BellCoin.png",
                SellPrice = 160,
                Time = "4am - 7pm",
                Location = "Flying",
                Icon = "Common_bluebottle.png"
            };

            Critters.Add(TestCritterOne);
            Critters.Add(TestCritterTwo);
        }
    }
}
