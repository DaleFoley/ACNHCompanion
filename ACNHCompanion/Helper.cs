using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion
{
    public static class Helper
    {
        public static void UpdateCritterIsDonated(TappedEventArgs args)
        {
            Critter critterSelected = (Critter)args.Parameter;

            int critterID = critterSelected.Id;
            bool isDonated = critterSelected.IsDonated ? false : true;

            App.ApplicationDatabase.UpdateCritterIsDonated(critterID, isDonated);
            critterSelected.IsDonated = isDonated;
        }
    }
}
