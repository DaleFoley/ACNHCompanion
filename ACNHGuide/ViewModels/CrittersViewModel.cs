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
            DatabaseManager db = new DatabaseManager();
            List<DBModels.Critter> dbCritters = db.GetAllCritters();

            Title = "Critters";
            Critters = new List<Critter>();

            foreach (DBModels.Critter dbCritter in dbCritters)
            {
                string pathToImage = "";
                if(dbCritter.type == "bug")
                {
                    pathToImage = "bug/" + dbCritter.image_name;
                }
                else if(dbCritter.type == "fish")
                {
                    pathToImage = "fish/" + dbCritter.image_name;
                }

                Models.Critter critterToAdd = new Models.Critter
                {
                    Name = dbCritter.critter_name,
                    SellIcon = "BellCoin.png",
                    SellPrice = dbCritter.sell_price,
                    Time = dbCritter.time,
                    Location = dbCritter.location,
                    IsDonated = dbCritter.is_donated,
                    Months = dbCritter.months,
                    Icon = pathToImage
                };

                Critters.Add(critterToAdd);
            }
        }
    }
}
