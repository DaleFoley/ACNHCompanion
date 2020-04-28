using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Linq;
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

        public static DateTime GetUserCustomDateTime()
        {
            DateTime newDateTime = DateTime.Now;

            Config customUserTimeDifference = App.Config.Where(config => config.Name == "customUserTimeDifference").FirstOrDefault();
            string customUserTimeDifferenceValue = customUserTimeDifference.Value;

            if (!string.IsNullOrEmpty(customUserTimeDifferenceValue))
            {
                DateTime currentDateTime = DateTime.Now;

                //TODO: constant minute string.
                customUserTimeDifferenceValue = customUserTimeDifferenceValue.Replace(" minute", "");

                double totalMinutes;
                bool isTotalMinutesValid = double.TryParse(customUserTimeDifferenceValue, out totalMinutes);

                if (isTotalMinutesValid)
                {
                    newDateTime = currentDateTime.AddMinutes(totalMinutes);
                }
            }

            return newDateTime;
        }
    }
}
