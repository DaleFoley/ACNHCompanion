using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class BugsViewModel : BaseViewModel
    {
        public BugsViewModel()
        {
            RefreshViewModel();
        }

        public void RefreshViewModel()
        {
            List<DBModels.CritterMonth> dbCritters = App.ApplicationDatabase.GetBugsNorthern();

            Title = "Bugs";

            //TODO: DRY
            foreach (DBModels.CritterMonth dbCritter in dbCritters)
            {
                Models.Critter critterToAdd = new Models.Critter
                {
                    Id = dbCritter.id,
                    Name = dbCritter.critter_name,
                    SellIcon = "BellCoin.png",
                    SellPrice = dbCritter.sell_price,
                    Time = dbCritter.time,
                    Location = dbCritter.location,
                    IsDonated = dbCritter.is_donated,
                    Months = dbCritter.months,
                    Rarity = dbCritter.rarity,
                    Icon = dbCritter.image_name,
                    Type = dbCritter.type
                };

                Critters.Add(critterToAdd);
            }
        }
    }
}
