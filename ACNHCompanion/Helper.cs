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

            if (isDonated)
            {
                App.ApplicationDatabase.UpdateCritterIsCaptured(critterID, isDonated);
                critterSelected.IsCaptured = isDonated;
            }
        }

        public static void UpdateCritterIsCaptured(TappedEventArgs args)
        {
            Critter critterSelected = (Critter)args.Parameter;

            int critterID = critterSelected.Id;
            bool isCaptured = critterSelected.IsCaptured ? false : true;

            App.ApplicationDatabase.UpdateCritterIsCaptured(critterID, isCaptured);
            critterSelected.IsCaptured = isCaptured;

            if (!isCaptured)
            {
                App.ApplicationDatabase.UpdateCritterIsDonated(critterID, isCaptured);
                critterSelected.IsDonated = isCaptured;
            }
        }

        public static void UpdateCritterIsSculpted(TappedEventArgs args)
        {
            Critter critterSelected = (Critter)args.Parameter;

            int critterID = critterSelected.Id;
            bool isSculpted = critterSelected.IsSculpted ? false : true;

            App.ApplicationDatabase.UpdateCritterIsSculpted(critterID, isSculpted);
            critterSelected.IsSculpted = isSculpted;
        }

        public static DateTime GetUserCustomDateTime()
        {
            DateTime newDateTime = DateTime.Now;

            Config customUserTimeDifference = App.Config.Where(config => config.Name == Strings.Config.CUSTOM_USER_TIME_DIFFERENCE).FirstOrDefault();
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
