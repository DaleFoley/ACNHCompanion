using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class BugsViewModel : BaseViewModel
    {
        public List<Critter> Critters { get; set; }

        public BugsViewModel()
        {
            DatabaseManager db = new DatabaseManager();
            List<DBModels.Critter> dbCritters = db.GetBugsNorthern();

            Title = "Bugs";
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
