using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace ACNHGuide.Models
{
    public class Critter
    {
        public bool IsDonated = false;
        public string Name { get; set; }
        public string SellIcon { get; set; }
        public long SellPrice { get; set; }

        public string Location { get; set; }
        public string Icon { get; set; }
        public string Time { get; set; }
        public string Months { get; set; }
        public double SellPricePenalty
        {
            get
            {
                int percentPenalty = 20; //Config, but I doubt AC will change this value.
                double penaltyToApply = (double)percentPenalty / 100 * SellPrice;

                return SellPrice - penaltyToApply;
            }
        }
        public long SellPriceBonus
        {
            get
            {
                double bonusToApply = 1.5;
                return (long)(SellPrice * bonusToApply);
            }
        }

        public string DonatedIcon
        {
            get
            {
                if(IsDonated)
                {
                    return "donated.png";
                }
                else
                {
                    return "donated_false.png";
                }
            }
        }
    }
}
