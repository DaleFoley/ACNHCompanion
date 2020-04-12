using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Xamarin.Forms;

using ACNHCompanion.Models;
using ACNHCompanion.Views;

namespace ACNHCompanion.ViewModels
{
    public class CrittersViewModel : BaseViewModel
    {
        public List<Critter> Critters { get; set; }

        public CrittersViewModel()
        {
            DatabaseManager db = new DatabaseManager();
            List<DBModels.Critter> dbCritters = db.GetFishNorthern();

            Title = "Fish";
            Critters = new List<Critter>();

            foreach (DBModels.Critter dbCritter in dbCritters)
            {
                Models.Critter critterToAdd = new Models.Critter
                {
                    Name = dbCritter.critter_name,
                    SellIcon = "BellCoin.png",
                    SellPrice = dbCritter.sell_price,
                    Time = dbCritter.time,
                    Location = dbCritter.location,
                    IsDonated = dbCritter.is_donated,
                    Months = dbCritter.months,
                    Rarity = dbCritter.rarity,
                    Icon = dbCritter.image_name
                };

                Critters.Add(critterToAdd);
            }
        }
    }
}
